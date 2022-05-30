package main

import (
	"context"
	"errors"
	"fmt"
	"net"
	"net/http"
	"net/rpc"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/arsham/awesome-sensors/contract"
	"github.com/godbus/dbus/v5"
	"github.com/sirupsen/logrus"
)

var logger = logrus.StandardLogger()

var errIgnore = errors.New("ignore")

const socket = "/tmp/awesomewm-sensors.sock"

type Server struct {
	conn *dbus.Conn
}

func (s *Server) Notify(m *contract.Message, reply *bool) error {
	dest := "org.awesomewm.awful"
	meth := dest + ".Remote.Eval"
	obj := s.conn.Object(dest, "/")
	fmt.Println("Got message with:", m.Title)
	msg := fmt.Sprintf(`require("naughty").notify({
		text = %q,
		title = %q,
		timeout = %d,
		icon = %q
	})`, m.Msg, m.Title, m.Timeout, m.AppIcon)
	call := obj.Call(meth, 0, msg)
	*reply = true
	return call.Err
}

func (s *Server) Emit(m *contract.Signal, reply *bool) error {
	dest := "org.awesomewm.awful"
	meth := dest + ".Remote.Eval"
	obj := s.conn.Object(dest, "/")
	fmt.Println("Got signal:", m.Signal)
	msg := fmt.Sprintf(`client.emit_signal(%q)`, m.Signal)
	if m.Values != "" {
		msg = fmt.Sprintf(`client.emit_signal(%q, %s)`, m.Signal, m.Values)
	}
	call := obj.Call(meth, 0, msg)
	*reply = true
	return call.Err
}

func main() {
	ctx, cancel := signal.NotifyContext(context.Background(), syscall.SIGINT, syscall.SIGTERM, syscall.SIGHUP)
	defer cancel()
	conn, err := dbus.ConnectSessionBus()
	if err != nil {
		logger.Fatal("connecting to dbus", err)
	}
	defer conn.Close()

	if err := os.RemoveAll(socket); err != nil {
		logger.Fatal("removing socket", err)
	}

	srv := &Server{conn: conn}
	err = rpc.Register(srv)
	if err != nil {
		logger.Fatal(err)
	}
	rpc.HandleHTTP()

	l, err := net.Listen("unix", socket)
	if err != nil {
		logger.Fatal("listen error:", err)
	}
	defer l.Close()

	go func() {
		<-ctx.Done()
		logger.Info("closing rpc server")
		l.Close()
	}()

	fmt.Println("Serving rpc on", socket)
	go func() {
		err := http.Serve(l, nil)
		if errors.Is(err, net.ErrClosed) {
			return
		}
		if err != nil {
			logger.Fatalf("serving error: %T", err)
		}
	}()

	total := 3
	cmdCh := make(chan string, 10)

	for i := 0; i < total; i++ {
		go func() {
			for msg := range cmdCh {
				dest := "org.awesomewm.awful"
				meth := dest + ".Remote.Eval"
				obj := conn.Object(dest, "/")
				call := obj.Call(meth, 0, msg)
				if call.Err != nil {
					logger.Error(call.Err)
				}
			}
		}()
	}

	m, err := newMetrics()
	if err != nil {
		logger.Fatal(err)
	}

	cpuFunc := func() {
		err := m.prepareCPU()
		if err != nil {
			logger.Error(err)
			return
		}
		cmdCh <- fmt.Sprintf(`client.emit_signal("go::cpu:temp", %d)`, m.cpuTemp())
		cmdCh <- fmt.Sprintf(`client.emit_signal("go::cpu:fan", %d)`, m.cpuFan())
	}

	battery, err := newBattery(ctx)
	if err != nil {
		logger.Error(err)
		return
	}
	go func() {
		for b := range battery {
			cmdCh <- fmt.Sprintf(`client.emit_signal("go::battery:value", %q, %q)`, b.msg, b.icon)
		}
	}()

	gpuCh, err := newGPU(ctx)
	if err != nil {
		logger.Error(err)
		return
	}
	go func() {
		for value := range gpuCh {
			cmdCh <- fmt.Sprintf(`client.emit_signal("go::gpu:temp", %d)`, value.temp)
		}
	}()

	var lastDropboxMsg, lastDropboxIcon string
	dropboxFunc := func() {
		ctx, cancel := context.WithTimeout(ctx, time.Second)
		defer cancel()
		msg, icon, err := dropbox(ctx)
		if err != nil {
			logger.Error(err)
			return
		}
		if lastDropboxMsg != msg || lastDropboxIcon != icon {
			cmdCh <- fmt.Sprintf(`client.emit_signal("go::dropbox:value", %q, %q)`, msg, icon)
			lastDropboxMsg = msg
			lastDropboxIcon = icon
		}
	}

	var lastMem, lastSwap string
	memFunc := func() {
		mem, swap, err := memory()
		if err != nil {
			return
		}
		if mem != lastMem {
			cmdCh <- fmt.Sprintf(`client.emit_signal("go::memory:mem", %q)`, mem)
			lastMem = mem
		}
		if swap != lastSwap {
			cmdCh <- fmt.Sprintf(`client.emit_signal("go::memory:swap", %q)`, swap)
			lastSwap = swap
		}
	}

	lastNet := &netValue{}
	netFunc := func() {
		value, err := network()
		if err != nil {
			return
		}
		if value.upString != lastNet.upString || value.downString != lastNet.downString {
			cmdCh <- fmt.Sprintf(`client.emit_signal("go::network:value", %q, %q, %d, %d)`,
				value.upString, value.downString, int(value.upValue), int(value.downValue))
			lastNet = value
		}
	}

	funcs := []func(){cpuFunc, dropboxFunc, memFunc, netFunc}

	for _, fn := range funcs {
		go func(fn func()) {
			ticker := time.NewTicker(time.Second / 2)
			defer ticker.Stop()
			for {
				select {
				case <-ctx.Done():
					return
				case <-ticker.C:
				}
				fn()
			}
		}(fn)
	}

	<-ctx.Done()
	logger.Info("shutting down")
}
