#!/bin/bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

info()  { printf '\033[1;34m[INFO]\033[0m  %s\n' "$1"; }
warn()  { printf '\033[1;33m[WARN]\033[0m  %s\n' "$1"; }
ok()    { printf '\033[1;32m[ OK ]\033[0m  %s\n' "$1"; }
err()   { printf '\033[1;31m[ERR ]\033[0m  %s\n' "$1"; }

link_file() {
    local src="$1" dst="$2"
    if [ -L "$dst" ]; then
        rm "$dst"
    elif [ -e "$dst" ]; then
        mkdir -p "$BACKUP_DIR"
        mv "$dst" "$BACKUP_DIR/$(basename "$dst")"
        warn "Backed up existing $dst -> $BACKUP_DIR/"
    fi
    mkdir -p "$(dirname "$dst")"
    ln -sf "$src" "$dst"
    ok "Linked $dst -> $src"
}

# --------------------------------------------------
# 1. APT packages
# --------------------------------------------------
info "Installing apt packages..."
sudo apt update -qq
sudo apt install -y \
    tmux \
    fzf \
    wl-clipboard \
    zsh \
    git \
    curl \
    wget \
    unzip \
    ripgrep \
    fd-find \
    build-essential

ok "APT packages installed"

# --------------------------------------------------
# 2. Neovim (stable from PPA)
# --------------------------------------------------
if ! command -v nvim &>/dev/null; then
    info "Installing Neovim..."
    sudo add-apt-repository -y ppa:neovim-ppa/stable
    sudo apt update -qq
    sudo apt install -y neovim
    ok "Neovim installed"
else
    ok "Neovim already installed ($(nvim --version | head -1))"
fi

# --------------------------------------------------
# 3. Oh My Zsh + plugins
# --------------------------------------------------
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    info "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    ok "Oh My Zsh installed"
else
    ok "Oh My Zsh already installed"
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
    info "Installing Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
    ok "Powerlevel10k installed"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    info "Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    ok "zsh-syntax-highlighting installed"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    info "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    ok "zsh-autosuggestions installed"
fi

# --------------------------------------------------
# 4. Tmux Plugin Manager
# --------------------------------------------------
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    info "Installing TPM (Tmux Plugin Manager)..."
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    ok "TPM installed"
else
    ok "TPM already installed"
fi

# --------------------------------------------------
# 5. Symlinks
# --------------------------------------------------
info "Creating symlinks..."

link_file "$DOTFILES/tmux/tmux.conf"              "$HOME/.tmux.conf"
link_file "$DOTFILES/tmux/workspace-picker.sh"     "$HOME/.tmux/workspace-picker.sh"

mkdir -p "$HOME/.tmux/workspaces"
link_file "$DOTFILES/tmux/workspaces/_template.sh" "$HOME/.tmux/workspaces/_template.sh"
link_file "$DOTFILES/tmux/workspaces/main.sh"      "$HOME/.tmux/workspaces/main.sh"

link_file "$DOTFILES/zsh/zshrc"                    "$HOME/.zshrc"
link_file "$DOTFILES/zsh/zshenv"                   "$HOME/.zshenv"
link_file "$DOTFILES/zsh/p10k.zsh"                 "$HOME/.p10k.zsh"

link_file "$DOTFILES/git/gitconfig"                "$HOME/.gitconfig"

link_file "$DOTFILES/wezterm/wezterm.lua"          "$HOME/.wezterm.lua"

if [ -d "$HOME/.config/nvim" ] && [ ! -L "$HOME/.config/nvim" ]; then
    mkdir -p "$BACKUP_DIR"
    mv "$HOME/.config/nvim" "$BACKUP_DIR/nvim"
    warn "Backed up existing nvim config"
fi
link_file "$DOTFILES/nvim"                         "$HOME/.config/nvim"

ok "All symlinks created"

# --------------------------------------------------
# 6. Set default shell to zsh
# --------------------------------------------------
if [ "$SHELL" != "$(which zsh)" ]; then
    info "Setting zsh as default shell..."
    chsh -s "$(which zsh)"
    ok "Default shell set to zsh"
else
    ok "zsh is already default shell"
fi

# --------------------------------------------------
# 7. Install tmux plugins
# --------------------------------------------------
info "Installing tmux plugins via TPM..."
"$HOME/.tmux/plugins/tpm/bin/install_plugins" || warn "Start tmux and press prefix+I to install plugins"

# --------------------------------------------------
# Done
# --------------------------------------------------
printf '\n\033[1;32m✓ Dotfiles installed successfully!\033[0m\n\n'
printf 'Next steps:\n'
printf '  1. Open a new terminal (or run: exec zsh)\n'
printf '  2. Start tmux: tmux\n'
printf '  3. Press Alt+w to open workspace picker\n'
printf '  4. Add custom workspaces: cp ~/.tmux/workspaces/_template.sh ~/.tmux/workspaces/myproject.sh\n'
printf '\n'
