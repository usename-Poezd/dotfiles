#!/bin/bash

C=$'\e[1m\e[38;2;137;180;250m'
DIM=$'\e[38;2;108;112;134m'
R=$'\e[0m'

WIN_W=$(tmux display-message -p '#{window_width}' 2>/dev/null || echo 200)
POPUP_W=$(( WIN_W * 65 / 100 - 2 ))
LOGO_W=48
PAD=$(( (POPUP_W - LOGO_W) / 2 ))
[ $PAD -lt 0 ] && PAD=0
P=$(printf '%*s' $PAD '')

HEADER="



${C}${P}███████╗██████╗  █████╗  ██████╗███████╗███████╗
${P}██╔════╝██╔══██╗██╔══██╗██╔════╝██╔════╝██╔════╝
${P}███████╗██████╔╝███████║██║     █████╗  ███████╗
${P}╚════██║██╔═══╝ ██╔══██║██║     ██╔══╝  ╚════██║
${P}███████║██║     ██║  ██║╚██████╗███████╗███████║
${P}╚══════╝╚═╝     ╚═╝  ╚═╝ ╚═════╝╚══════╝╚══════╝${R}

${DIM}${P}  j/k ↑↓ navigate   l/enter open   h/esc cancel${R}
"

ROW_W=$(( POPUP_W - 4 ))

selected=$(ls ~/.tmux/workspaces/*.sh 2>/dev/null \
    | grep -v '_template' \
    | xargs -I{} basename {} .sh \
    | sed 's/\.\.*//' \
    | while read -r name; do printf "  󰆍  %-${ROW_W}s\n" "$name"; done \
    | fzf --ansi --reverse --header-first \
          --header="$HEADER" \
          --no-info \
          --border=rounded \
          --prompt='   󰍉  ' \
          --pointer=' ' \
          --ellipsis='' \
          --separator='─' \
          --scrollbar='│' \
          --bind 'j:down,k:up,l:accept,h:abort,alt-q:abort' \
          --color='bg:#1e1e2e,bg+:#313244,fg:#a6adc8,fg+:#cdd6f4,hl:#89b4fa,hl+:#89b4fa,pointer:#1e1e2e,gutter:#1e1e2e,prompt:#89b4fa,border:#89b4fa,separator:#45475a,header:#89b4fa' \
    | sed 's/^  󰆍  //' | sed 's/ *$//')

[ -n "$selected" ] && bash ~/.tmux/workspaces/"$selected".sh
