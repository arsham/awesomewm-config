package main

import (
	"os"
	"regexp"
	"strconv"
	"strings"
)

var re = regexp.MustCompile(`^(?P<name>[^:]+):\s+(?P<value>[^\s]+)`)

func lineContainsAny(line string, items ...string) bool {
	for _, item := range items {
		if strings.Contains(line, item) {
			return true
		}
	}
	return false
}

func humanReadableBytes(b float64) string {
	b = b * 1024
	if b < 1024 {
		return strconv.FormatFloat(b, 'f', 1, 32) + "B"
	}
	if b < 1024*1024 {
		return strconv.FormatFloat(b/1024.0, 'f', 2, 64) + "K"
	}
	if b < 1024*1024*1024 {
		return strconv.FormatFloat(b/1024.0/1024.0, 'f', 2, 64) + "M"
	}
	return strconv.FormatFloat(b/1024.0/1024.0/1024.0, 'f', 2, 64) + "G"
}

func memory() (mem, swap string, err error) {
	contents, err := os.ReadFile("/proc/meminfo")
	if err != nil {
		logger.Error(err)
		return "", "", err
	}

	lines := strings.Split(string(contents), "\n")
	var memTotal int
	var memAvail int
	var swapFree int
	var swapTotal int
	for _, line := range lines {
		if line == "" {
			continue
		}
		if !lineContainsAny(line, "MemTotal", "MemAvailable", "SwapTotal", "SwapFree") {
			continue
		}
		match := re.FindStringSubmatch(line)
		if match == nil {
			continue
		}
		name := match[1]
		value := match[2]
		switch name {
		case "MemTotal":
			memTotal, err = strconv.Atoi(value)
			if err != nil {
				return "", "", err
			}
		case "MemAvailable":
			memAvail, err = strconv.Atoi(value)
			if err != nil {
				return "", "", err
			}
		case "SwapFree":
			swapFree, err = strconv.Atoi(value)
			if err != nil {
				return "", "", err
			}
		case "SwapTotal":
			swapTotal, err = strconv.Atoi(value)
			if err != nil {
				return "", "", err
			}
		}
	}

	memFree := memAvail
	memInuse := memTotal - memFree
	swapInUse := swapTotal - swapFree
	return humanReadableBytes(float64(memInuse)), humanReadableBytes(float64(swapInUse)), nil
}
