package main

import (
	"context"
	"os/exec"
	"strings"
)

func dropbox(ctx context.Context) (msg, icon string, err error) {
	cmd := exec.CommandContext(ctx, "dropbox-cli", "status")
	out, err := cmd.CombinedOutput()
	if err != nil {
		return "", "", err
	}

	lines := strings.Split(string(out), "\n")
	messages := make([]string, 0, len(lines))
	for _, line := range lines {
		if line == "" {
			continue
		}
		if strings.Contains(line, "deprecate") || strings.Contains(line, "stop_event") {
			continue
		}
		messages = append(messages, line)
	}
	msg = strings.Join(messages, "\n")

	switch {
	case strings.Contains(msg, "date"):
		icon = "dropbox_status_idle"
	case strings.Contains(msg, "Syncing"):
		fallthrough
	case strings.Contains(msg, "Downloading file list"):
		fallthrough
	case strings.Contains(msg, "Connecting"):
		fallthrough
	case strings.Contains(msg, "Starting"):
		fallthrough
	case strings.Contains(msg, "Indexing"):
		icon = "dropbox_loading_icon"
	case strings.Contains(msg, "Dropbox isn't running"):
		icon = "dropbox_status_x"
	}

	return msg, icon, nil
}
