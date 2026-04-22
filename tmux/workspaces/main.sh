#!/bin/bash
SESSION="main"

tmux has-session -t "$SESSION" 2>/dev/null && {
    tmux switch-client -t "$SESSION" 2>/dev/null || tmux attach -t "$SESSION"
    exit 0
}

tmux new-session -d -s "$SESSION" -c "$HOME"
tmux switch-client -t "$SESSION" 2>/dev/null || tmux attach -t "$SESSION"
