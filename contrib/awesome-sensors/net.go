package main

import (
	"os"
	"regexp"
	"strconv"
	"strings"
	"time"
)

type netValue struct {
	upValue    float64
	downValue  float64
	upString   string
	downString string
	time       time.Time
}

var prev = &netValue{}

var stringRe = regexp.MustCompile(`\s+`)

func network() (*netValue, error) {
	contents, err := os.ReadFile("/proc/net/dev")
	if err != nil {
		logger.Error(err)
		return nil, err
	}

	lines := strings.Split(string(contents), "\n")
	var line string
	for _, l := range lines {
		if strings.Contains(l, "wlp59s0") {
			line = l
			break
		}
	}

	transmits := stringRe.Split(line, 11)
	rx, tx := transmits[1], transmits[9]
	now := time.Now()
	ret := &netValue{time: now}
	if prev.upValue == 0 {
		prev.time = now
		prev.downValue, err = strconv.ParseFloat(rx, 64)
		if err != nil {
			logger.Error(err)
			return nil, err
		}
		prev.upValue, err = strconv.ParseFloat(tx, 64)
		if err != nil {
			logger.Error(err)
			return nil, err
		}
		return nil, errIgnore
	}
	interval := now.Sub(prev.time).Seconds() * 1000
	if interval == 0 {
		interval = float64(time.Second * 1000)
	}
	down, err := strconv.ParseFloat(rx, 64)
	if err != nil {
		logger.Error(err)
		return nil, err
	}
	up, err := strconv.ParseFloat(tx, 64)
	if err != nil {
		logger.Error(err)
		return nil, err
	}
	prev.time = now
	prevDown := prev.downValue
	prevUp := prev.upValue
	prev.downValue = down
	prev.upValue = up

	down = (down - prevDown) / interval
	up = (up - prevUp) / interval

	ret.upValue = up
	ret.downValue = down
	ret.upString = humanReadableBytes(up)
	ret.downString = humanReadableBytes(down)
	return ret, nil
}
