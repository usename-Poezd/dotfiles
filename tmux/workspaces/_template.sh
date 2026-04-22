#!/bin/bash
# ============================================================
# Workspace Template
# Скопируй этот файл и переименуй: cp _template.sh myproject.sh
# Имя файла (без .sh) = имя в fzf-меню
# ============================================================

SESSION="myproject"                          # Имя tmux-сессии
ROOT="$HOME/work/myproject"                  # Корневая директория

# --- Если сессия уже запущена — просто переключиться ---
tmux has-session -t "$SESSION" 2>/dev/null && {
    tmux switch-client -t "$SESSION" 2>/dev/null || tmux attach -t "$SESSION"
    exit 0
}

# === Окно 1: editor ===
tmux new-session -d -s "$SESSION" -c "$ROOT" -n "editor"
tmux send-keys -t "$SESSION:editor" "nvim" Enter

# === Окно 2: shells (вертикальный split — два pane рядом) ===
tmux new-window -t "$SESSION" -c "$ROOT" -n "shells"
tmux split-window -t "$SESSION:shells" -h -c "$ROOT"
# Левый pane: пустой shell
# Правый pane: пустой shell (или команда)
# tmux send-keys -t "$SESSION:shells.2" "docker compose logs -f" Enter

# === Окно 3: monitoring (горизонтальный split — один над другим) ===
# Раскомментируй если нужно:
# tmux new-window -t "$SESSION" -c "$ROOT" -n "monitoring"
# tmux send-keys -t "$SESSION:monitoring" "htop" Enter
# tmux split-window -t "$SESSION:monitoring" -v -c "$ROOT"
# tmux send-keys -t "$SESSION:monitoring.2" "watch -n2 df -h" Enter

# === Сложный layout (2x2 grid) ===
# tmux new-window -t "$SESSION" -c "$ROOT" -n "grid"
# tmux split-window -t "$SESSION:grid" -h -c "$ROOT"
# tmux split-window -t "$SESSION:grid.1" -v -c "$ROOT"
# tmux split-window -t "$SESSION:grid.2" -v -c "$ROOT"
# Результат: 4 pane в сетке 2x2

# --- Переключиться на первое окно и подключиться ---
tmux select-window -t "$SESSION:editor"
tmux switch-client -t "$SESSION" 2>/dev/null || tmux attach -t "$SESSION"
