package main

import (
	"context"
	"fmt"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/godbus/dbus/v5"
	"github.com/sirupsen/logrus"
)

var logger = logrus.StandardLogger()

const socket = "/tmp/awesomewm-sensors.sock"

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

	funcs := []func(){cpuFunc, dropboxFunc}

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
