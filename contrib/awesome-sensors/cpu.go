package main

import (
	"context"
	"fmt"
	"math/big"
	"os/exec"
	"regexp"
	"strconv"
	"strings"
	"sync"

	linuxproc "github.com/c9s/goprocinfo/linux"
	"github.com/mdlayher/lmsensors"
)

var (
	adapter string
	low     = 50
	high    = 80
	fanRe   = regexp.MustCompile(`fan\d:\s+(\d+)\s+RPM`)
)

type cpu struct {
	total uint64
	idle  uint64
}

type metrics struct {
	cpuT      int
	cpuF      int
	gpuOut    string
	cpuUsage  map[int]int
	cpuTotal  map[int]int
	cpuActive map[int]int
	prevCPU   []cpu
	mu        sync.RWMutex
	cpuCalls  int
}

func newMetrics() (*metrics, error) {
	m := &metrics{
		cpuUsage:  make(map[int]int),
		cpuTotal:  make(map[int]int),
		cpuActive: make(map[int]int),
	}
	prevCPULoad, err := linuxproc.ReadStat("/proc/stat")
	if err != nil {
		return nil, err
	}
	m.prevCPU = getCPUStats(prevCPULoad.CPUStats)
	return m, nil
}

func (m *metrics) prepareCPU() error {
	m.mu.Lock()
	defer m.mu.Unlock()

	var (
		fanTotal  float32
		fanCount  float32
		tempTotal float64
		tempCount float64
	)

	s := lmsensors.New()
	devices, err := s.Scan()
	if err != nil {
		return err
	}
	for _, d := range devices {
		switch d.Name {
		case "coretemp-00":
			for _, sensors := range d.Sensors {
				value, ok := sensors.(*lmsensors.TemperatureSensor)
				if !ok {
					continue
				}
				tempTotal += value.Input
				tempCount++
			}
		case "dell_smm-00":
			for _, sensors := range d.Sensors {
				value, ok := sensors.(*lmsensors.FanSensor)
				if !ok {
					continue
				}
				if value.Input == 0 {
					fanCount--
				}
				fanTotal += float32(value.Input)
				fanCount++
			}
		}
	}
	if fanCount < 1 {
		fanCount = 1
	}

	value := tempTotal / tempCount
	value = (value - 45) / 55 * 100
	m.cpuT = int(value)

	// the range of value is 2200 to 5000 RPM
	// we need to return a value between 0 and 100
	// fanTotal = 3202
	m.cpuF = int(((fanTotal / fanCount) - 2200) / (5000.0 - 2200.0) * 100)
	return nil
}

func (m *metrics) cpuTemp() int {
	m.mu.RLock()
	defer m.mu.RUnlock()
	return m.cpuT
}

func (m *metrics) cpuFan() int {
	m.mu.RLock()
	defer m.mu.RUnlock()
	return m.cpuF
}

func (m *metrics) gpuTemp(ctx context.Context) int {
	cmd := exec.CommandContext(ctx, "nvidia-smi", "--query-gpu=fan.speed,temperature.gpu", "--format=csv,noheader")
	out, err := cmd.CombinedOutput()
	if err != nil {
		return 0
	}
	m.gpuOut = string(out)

	tempTotal := 0
	tempCount := 0
	lines := strings.Split(m.gpuOut, "\n")
	for _, line := range lines {
		_, value, ok := strings.Cut(line, ",")
		if !ok {
			continue
		}
		value = strings.Trim(value, " %")
		i, err := strconv.Atoi(value)
		if err == nil {
			tempTotal += i
			tempCount++
		}
	}

	value := tempTotal / tempCount
	value = int((float32(value) - 40) / 60 * 100)
	return value
}

func (m *metrics) cpuLoad() int {
	stat, err := linuxproc.ReadStat("/proc/stat")
	if err != nil {
		return 0
	}

	newCPUInfo := getCPUStats(stat.CPUStats)
	total := 0
	// const fac = 100_000_000_000_000
	for i := range newCPUInfo {
		newTotal := big.NewFloat(float64(m.prevCPU[i].total))
		newIdle := big.NewFloat(float64(newCPUInfo[i].idle))
		prevTotal := big.NewFloat(float64(newCPUInfo[i].total))
		prevIdle := big.NewFloat(float64(m.prevCPU[i].idle))
		fmt.Println(newTotal, prevTotal, newIdle, prevIdle)
		// ((Total-PrevTotal)-(Idle-PrevIdle))/(Total-PrevTotal)*100
		// a := newTotal-prevTotal-newIdle+prevIdle
		// b := newTotal-prevTotal
		// cpuPercentage := a / b * 100
		a := newTotal.Sub(newTotal, prevTotal)
		b := a.Copy(a)
		a = a.Sub(a, newIdle)
		a = a.Add(a, prevIdle)
		cpuPercentage, _ := a.Quo(a, b).Float64()

		total += int(cpuPercentage) * 100
	}
	m.prevCPU = newCPUInfo
	fmt.Println(total / len(newCPUInfo))
	return total / len(newCPUInfo)
}

func getCPUStats(stats []linuxproc.CPUStat) []cpu {
	cpuInfos := []cpu{}
	for _, cpuLine := range stats {
		idle := cpuLine.Idle + cpuLine.IOWait
		nonIdle := cpuLine.User + cpuLine.Nice + cpuLine.System +
			cpuLine.IRQ + cpuLine.SoftIRQ + cpuLine.Steal
		total := idle + nonIdle
		cpuInfos = append(cpuInfos, cpu{total: total, idle: idle})
	}
	return cpuInfos
}
