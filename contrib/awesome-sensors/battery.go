package main

import (
	"bufio"
	"context"
	"os/exec"
	"strconv"
	"strings"
)

type bat struct {
	msg  string
	icon string
}

func newBattery(ctx context.Context) (chan bat, error) {
	cmd := exec.CommandContext(ctx, "upower", "--monitor-detail")
	cmdReader, err := cmd.StdoutPipe()
	if err != nil {
		return nil, err
	}
	err = cmd.Start()
	if err != nil {
		return nil, err
	}
	lastBat, err := battery(ctx)
	if err != nil {
		return nil, err
	}

	scanner := bufio.NewScanner(cmdReader)
	ch := make(chan bat, 10)
	ch <- *lastBat
	go func() {
		defer close(ch)
		b := bat{}
		var (
			begin, end       bool
			batCharge, state string
			percentage       int
			remaining        string
		)
		for scanner.Scan() {
			select {
			case <-ctx.Done():
				return
			default:
			}
			line := scanner.Text()
			line = strings.Trim(line, " ")
			if strings.HasPrefix(line, "present") {
				begin = true
			}
			if strings.HasPrefix(line, "icon-name") {
				end = true
			}
			if !begin {
				continue
			}
			key, value, _ := strings.Cut(line, ":")
			value = strings.Trim(value, " ")
			switch key {
			case "state":
				state = value
			case "percentage":
				batCharge = strings.Trim(value, "%")
				percentage, _ = strconv.Atoi(batCharge)
				b.icon = batCharge
			case "time to full":
				remaining = "Time to fully charged: " + value
			case "time to empty":
				remaining = "Time to empty: " + value
			}

			if end {
				if state == "discharging" {
					b.icon = "charge"
				}
				if state == "charging" || state == "charge" {
					b.icon = "charging"
				}
				switch {
				case percentage < 20:
					b.icon += "_00"
				case percentage < 40:
					b.icon += "_20"
				case percentage < 60:
					b.icon += "_40"
				case percentage < 80:
					b.icon += "_60"
				case percentage < 100:
					b.icon += "_80"
				case percentage == 100:
					b.icon = "charge_100"
				}

				b.msg = "Charge: " + batCharge
				if len(remaining) > 0 {
					b.msg += "\n" + remaining
				}
				if state == "fully-charged" {
					b.icon = "charged"
				}

				ch <- b
				b = bat{}
				end = false
			}
		}
	}()
	return ch, nil
}

func battery(ctx context.Context) (*bat, error) {
	cmd := exec.CommandContext(ctx, "upower", "-i", "/org/freedesktop/UPower/devices/battery_BAT0")
	b := &bat{}
	out, err := cmd.CombinedOutput()
	if err != nil {
		return nil, err
	}
	var begin, end bool
	var (
		batCharge, state string
		percentage       int
		remaining        string
	)
	for _, line := range strings.Split(string(out), "\n") {
		line = strings.Trim(line, " ")
		if strings.HasPrefix(line, "present") {
			begin = true
		}
		if strings.HasPrefix(line, "icon-name") {
			end = true
		}
		if !begin {
			continue
		}
		key, value, _ := strings.Cut(line, ":")
		value = strings.Trim(value, " ")
		switch key {
		case "state":
			state = value
		case "percentage":
			batCharge = strings.Trim(value, "%")
			percentage, _ = strconv.Atoi(batCharge)
			b.icon = batCharge
		case "time to full":
			remaining = "Time to fully charged: " + value
		case "time to empty":
			remaining = "Time to empty: " + value
		}
		if end {
			break
		}
	}

	if state == "discharging" {
		b.icon = "charge"
	}
	if state == "charging" || state == "charge" {
		b.icon = "charging"
	}
	switch {
	case percentage < 20:
		b.icon += "_00"
	case percentage < 40:
		b.icon += "_20"
	case percentage < 60:
		b.icon += "_40"
	case percentage < 80:
		b.icon += "_60"
	case percentage < 100:
		b.icon += "_80"
	case percentage == 100:
		b.icon = "100"
	}

	b.msg = "Charge: " + batCharge
	if len(remaining) > 0 {
		b.msg += "\n" + remaining
	}
	if state == "fully-charged" {
		b.icon = "charged"
	}
	return b, nil
}
