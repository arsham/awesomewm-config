package main

import (
	"bufio"
	"context"
	"os/exec"
	"strconv"
	"strings"
)

type gpu struct {
	fan  int
	temp int
}

func newGPU(ctx context.Context) (chan gpu, error) {
	cmd := exec.CommandContext(ctx, "nvidia-smi", "--query-gpu=fan.speed,temperature.gpu", "--format=csv,noheader", "-l", "1")
	cmdReader, err := cmd.StdoutPipe()
	if err != nil {
		return nil, err
	}
	err = cmd.Start()
	if err != nil {
		return nil, err
	}

	scanner := bufio.NewScanner(cmdReader)
	ch := make(chan gpu, 10)
	go func() {
		defer close(ch)
		for scanner.Scan() {
			select {
			case <-ctx.Done():
				return
			default:
			}
			line := scanner.Text()

			tempTotal := 0
			tempCount := 0
			lines := strings.Split(line, "\n")
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
			ch <- gpu{
				temp: value,
			}
		}
	}()
	return ch, nil
}
