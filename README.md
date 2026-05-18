# Dotfiles

Personal development environment for Ubuntu (Wayland).

## Quick Start

```bash
git clone <repo-url> ~/dotfiles
cd ~/dotfiles
./install.sh
```

The installer backs up any existing configs to `~/.dotfiles-backup/<timestamp>/` before overwriting.

## What's Inside

### Tmux

Prefix-free keybindings — everything is `Alt+key`, no prefix chord needed.

**Workspace system** — define reusable workspace scripts in `~/.tmux/workspaces/`. Each script creates a tmux session with a predefined layout, splits, and commands. Press `Alt+w` to open a LazyVim-style fzf picker with catppuccin colors and vim navigation.

Workspace scripts are idempotent: if the session already exists, it switches to it instead of creating a duplicate.

| Key | Action |
|-----|--------|
| `Alt+w` | Workspace picker (fzf popup) |
| `Alt+l` | Open/attach opencode popup for current directory |
| `Alt+s` | Session tree (all live sessions) |
| `Alt+Ctrl+s` | New session in current directory |
| `Alt+t` | New window |
| `Alt+1-9` | Switch to window N |
| `Alt+h` | Horizontal split |
| `Alt+v` | Vertical split |
| `Alt+arrows` | Navigate panes |
| `Ctrl+arrows` | Resize panes |
| `Alt+c` | Kill pane |
| `Alt+q` | Kill window |
| `Alt+Q` | Kill session (with confirmation) |
| `Alt+d` | Detach |
| `Alt+r` | Rename window |
| `Alt+Ctrl+r` | Rename session |
| `Alt+b` | Reload config |
| `Alt+/` | Search forward |
| `Alt+?` | Search backward |

**Copy/paste** (Wayland clipboard via `wl-copy`):
- Vi mode: enter copy-mode, `v` to select, `y` to yank to system clipboard
- Mouse: drag to select, release to copy to system clipboard
- Inside TUI apps (opencode, nvim): `Shift+mouse` to select at terminal level

**Creating a workspace:**

```bash
cp ~/.tmux/workspaces/_template.sh ~/.tmux/workspaces/myproject.sh
vim ~/.tmux/workspaces/myproject.sh
# Edit SESSION, ROOT, windows, splits, commands
# It will appear in Alt+w picker immediately
```

**Plugins** (managed by [TPM](https://github.com/tmux-plugins/tpm)):
- `tmux-sensible` — sensible defaults
- `catppuccin/tmux` — catppuccin mocha theme
- `tmux-resurrect` — save/restore sessions manually (`prefix+Ctrl+s` / `prefix+Ctrl+r`)
- `tmux-continuum` — auto-save every 15min (auto-restore disabled, workspace scripts are the primary session source)

### OpenCode + Oh My OpenAgent

[OpenCode](https://opencode.ai/) is a TUI AI coding assistant that runs inside tmux popups. Press `Alt+l` in any tmux pane to open an opencode instance scoped to the current directory. Each directory gets its own persistent popup session — dismiss with `Alt+q`, reopen with `Alt+l` and it picks up where you left off.

[Oh My OpenAgent](https://github.com/code-yeongyu/oh-my-opencode) is an opencode plugin that adds agent orchestration (multi-model routing, specialized subagents, skills system).

**Config locations:**
- `~/.config/opencode/` — default OpenCode + caveman
- `~/.config-omo/opencode/` — full Oh My OpenAgent (`omo` alias)
- `~/.config-omos/opencode/` — oh-my-opencode-slim (`omos` alias)

Configs are tracked under `opencode/`. ITooLabs proxy `baseURL` values are intentionally omitted.

`auth.json` is intentionally not tracked. Use one shared auth file and symlink it into all three presets:

```bash
mkdir -p ~/.config/opencode-auth
# Put/create auth.json here manually. Do not commit it.

ln -sf ~/.config/opencode-auth/auth.json ~/.config/opencode/auth.json
ln -sf ~/.config/opencode-auth/auth.json ~/.config-omo/opencode/auth.json
ln -sf ~/.config/opencode-auth/auth.json ~/.config-omos/opencode/auth.json
```

**Install:**

```bash
curl -fsSL https://opencode.ai/install | bash
```

Example minimal `~/.config-omo/opencode/opencode.json` plugin config:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "anthropic": {}
  },
  "plugin": [
    "oh-my-openagent@latest"
  ]
}
```

### Neovim

[LazyVim](https://www.lazyvim.org/) distribution. Config lives in `nvim/lua/`.

### Zsh

- [Oh My Zsh](https://ohmyz.sh/) framework
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k) prompt theme
- Plugins: `git`, `zsh-syntax-highlighting`, `zsh-autosuggestions`
- PATH setup for: opencode, bun, nvm, go, cargo

### WezTerm

- Catppuccin Mocha color scheme
- JetBrainsMono Nerd Font (ligatures disabled)
- Auto-attaches to tmux `main` session on launch
- Tab bar disabled (tmux handles tabs)

### Git

- Conditional includes: separate `.gitconfig-<profile>` per directory (e.g. work vs personal)

## Dependencies

Installed automatically by `install.sh`:

| Package | Purpose |
|---------|---------|
| `tmux` | Terminal multiplexer |
| `fzf` | Fuzzy finder (workspace picker) |
| `wl-clipboard` | Wayland clipboard (`wl-copy`) |
| `zsh` | Shell |
| `neovim` | Editor |
| `git` | Version control |
| `curl`, `wget` | Downloads |
| `ripgrep` | Fast grep (used by nvim telescope) |
| `fd-find` | Fast find (used by nvim telescope) |
| `build-essential` | C compiler (needed by some nvim plugins) |

**Installed from source by the script:**

| Tool | Purpose |
|------|---------|
| Oh My Zsh | Zsh framework |
| Powerlevel10k | Zsh prompt theme |
| zsh-syntax-highlighting | Syntax highlighting in shell |
| zsh-autosuggestions | Fish-like autosuggestions |
| TPM | Tmux Plugin Manager |

**Not managed (install separately):**

| Tool | Install |
|------|---------|
| OpenCode | `curl -fsSL https://opencode.ai/install \| bash` |
| WezTerm | [wezfurlong.org/wezterm](https://wezfurlong.org/wezterm/install/linux.html) |
| JetBrainsMono NF | [nerdfonts.com](https://www.nerdfonts.com/font-downloads) |
| Node.js (nvm) | `curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh \| bash` |
| Bun | `curl -fsSL https://bun.sh/install \| bash` |
| Go | [go.dev/dl](https://go.dev/dl/) |
| Rust (cargo) | `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \| sh` |

## Structure

```
dotfiles/
├── install.sh              # One-shot installer (apt + symlinks)
├── README.md
├── tmux/
│   ├── tmux.conf           # -> ~/.tmux.conf
│   ├── workspace-picker.sh # -> ~/.tmux/workspace-picker.sh
│   └── workspaces/
│       ├── _template.sh    # Workspace template (hidden from picker)
│       └── main.sh         # Default workspace (~/home)
├── nvim/                   # -> ~/.config/nvim/
│   ├── init.lua
│   ├── lazy-lock.json
│   └── lua/
├── zsh/
│   ├── zshrc               # -> ~/.zshrc
│   ├── zshenv              # -> ~/.zshenv
│   └── p10k.zsh            # -> ~/.p10k.zsh
├── wezterm/
│   └── wezterm.lua         # -> ~/.wezterm.lua
├── opencode/
│   ├── config/opencode/    # -> ~/.config/opencode/
│   ├── config-omo/         # -> ~/.config-omo/
│   └── config-omos/        # -> ~/.config-omos/
└── git/
    └── gitconfig           # -> ~/.gitconfig
```

## Adding Project-Specific Workspaces

Workspace scripts that are project-specific (company repos, private paths) should NOT go in this repo. Create them directly:

```bash
cat > ~/.tmux/workspaces/myproject.sh << 'EOF'
#!/bin/bash
SESSION="myproject"
ROOT="$HOME/work/myproject"

tmux has-session -t "$SESSION" 2>/dev/null && {
    tmux switch-client -t "$SESSION" 2>/dev/null || tmux attach -t "$SESSION"
    exit 0
}

tmux new-session -d -s "$SESSION" -c "$ROOT" -n "editor"
tmux send-keys -t "$SESSION:editor" "nvim" Enter

tmux select-window -t "$SESSION:editor"
tmux switch-client -t "$SESSION" 2>/dev/null || tmux attach -t "$SESSION"
EOF
chmod +x ~/.tmux/workspaces/myproject.sh
```

It will appear in `Alt+w` picker immediately. No config reload needed.
