#!/bin/sh

# Syncbin installation script
# Portable shell script for setting up dotfiles and configurations
# Compatible with sh, bash, zsh, and other POSIX shells

set -e  # Exit on any error

# Define SYNCBIN - get absolute path of script directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
export SYNCBIN="${SYNCBIN:-$SCRIPT_DIR}"

# Detect OS for platform-specific configurations
case "$(uname -s)" in
    Darwin) OS_TYPE="macos" ;;
    Linux)  OS_TYPE="linux" ;;
    FreeBSD) OS_TYPE="freebsd" ;;
    *) OS_TYPE="unknown" ;;
esac

# Helper function to create directory if it doesn't exist
ensure_dir() {
    [ ! -d "$1" ] && mkdir -p "$1"
}

# Helper function to create symlink safely
safe_symlink() {
    local src="$1"
    local dest="$2"
    
    if [ -f "$src" ] || [ -d "$src" ]; then
        # Remove existing file/symlink if it exists
        [ -e "$dest" ] || [ -L "$dest" ] && rm -rf "$dest"
        ln -sf "$src" "$dest"
        echo "✓ Linked $dest"
    else
        echo "⚠ Skipping $dest (source not found: $src)"
    fi
}

# Helper function to create symlink only if destination doesn't exist
safe_symlink_if_missing() {
    local src="$1"
    local dest="$2"
    
    if [ ! -e "$dest" ] && [ ! -L "$dest" ]; then
        if [ -f "$src" ] || [ -d "$src" ]; then
            ln -sf "$src" "$dest"
            echo "✓ Linked $dest"
        else
            echo "⚠ Skipping $dest (source not found: $src)"
        fi
    fi
}

echo "🚀 Installing syncbin configurations..."
echo "📂 SYNCBIN: $SYNCBIN"
echo "🖥️  OS: $OS_TYPE"
echo

#########################
## Create directories  ##
#########################
echo "📁 Creating configuration directories..."

# Standard config directories
ensure_dir "$HOME/.config/zsh"
ensure_dir "$HOME/.config/fish"
ensure_dir "$HOME/.config/broot"
ensure_dir "$HOME/.config/conda"
ensure_dir "$HOME/.config/zellij"
ensure_dir "$HOME/.config/lsd"
ensure_dir "$HOME/.config/micro"
ensure_dir "$HOME/.config/btop"
ensure_dir "$HOME/.config/bat"
ensure_dir "$HOME/.config/tmux"
ensure_dir "$HOME/.config/tmux/plugins"

# Platform-specific directories
if [ "$OS_TYPE" = "macos" ]; then
    ensure_dir "$HOME/.config/alacritty"
fi

echo

#########################
## Shell configurations ##
#########################
echo "🐚 Installing shell configurations..."

# ZSH configuration
safe_symlink "$SYNCBIN/zsh/zshrc.zsh" "$HOME/.zshrc"

# Bash configuration  
safe_symlink "$SYNCBIN/bash/bashrc" "$HOME/.bashrc"
safe_symlink "$SYNCBIN/bash/bash_profile" "$HOME/.bash_profile"

# Fish configuration
safe_symlink "$SYNCBIN/fish/config.fish" "$HOME/.config/fish/config.fish"

echo

#########################
## Core dotfiles       ##
#########################
echo "⚙️  Installing core dotfiles..."

safe_symlink "$SYNCBIN/screenrc" "$HOME/.screenrc"
safe_symlink "$SYNCBIN/zsh/theme/starship.toml" "$HOME/.config/starship.toml"
safe_symlink "$SYNCBIN/broot_conf.hjson" "$HOME/.config/broot/conf.hjson"
safe_symlink "$SYNCBIN/condarc" "$HOME/.config/conda/condarc"
safe_symlink "$SYNCBIN/zellij/zellij.kdl" "$HOME/.config/zellij/config.kdl"
safe_symlink "$SYNCBIN/btop/btop.conf" "$HOME/.config/btop/btop.conf"
safe_symlink "$SYNCBIN/bat/config" "$HOME/.config/bat/config"
safe_symlink "$SYNCBIN/tmux.conf" "$HOME/.config/tmux/tmux.conf"
safe_symlink "$SYNCBIN/lsd.conf.yml" "$HOME/.config/lsd/config.yaml"
safe_symlink "$SYNCBIN/micro/settings.json" "$HOME/.config/micro/settings.json"
safe_symlink "$SYNCBIN/micro/bindings.json" "$HOME/.config/micro/bindings.json"

echo

#########################
## R configuration     ##
#########################
echo "📊 Installing R configurations..."

safe_symlink "$SYNCBIN/R/Rprofile" "$HOME/.Rprofile"
safe_symlink "$SYNCBIN/R/radian_profile" "$HOME/.radian_profile"

echo

#########################
## Theme directories   ##
#########################
echo "🎨 Installing theme directories..."

safe_symlink_if_missing "$SYNCBIN/bat/themes" "$HOME/.config/bat/themes"
safe_symlink_if_missing "$SYNCBIN/btop/themes" "$HOME/.config/btop/themes"
safe_symlink_if_missing "$SYNCBIN/zellij/themes" "$HOME/.config/zellij/themes"
safe_symlink_if_missing "$SYNCBIN/helix" "$HOME/.config/helix"
safe_symlink_if_missing "$SYNCBIN/ghostty" "$HOME/.config/ghostty"
safe_symlink_if_missing "$SYNCBIN/micro/syntax" "$HOME/.config/micro/syntax"

echo

#########################
## Platform-specific   ##
#########################
if [ "$OS_TYPE" = "macos" ]; then
    echo "🍎 Installing macOS-specific configurations..."
    
    safe_symlink "$SYNCBIN/alacritty/alacritty.yml" "$HOME/.config/alacritty/alacritty.yml"
    safe_symlink_if_missing "$SYNCBIN/zed" "$HOME/.config/zed"
    
    echo
fi

#########################
## RStudio themes      ##
#########################
if [ -d "$HOME/.config/rstudio/themes/" ]; then
    echo "📈 Installing RStudio themes..."
    for theme in "$SYNCBIN/rstudio/themes"/*.rstheme; do
        if [ -f "$theme" ]; then
            safe_symlink "$theme" "$HOME/.config/rstudio/themes/$(basename "$theme")"
        fi
    done
    echo
fi

#########################
## Oh-My-Zsh setup     ##
#########################
echo "🔧 Setting up Oh-My-Zsh..."

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh-My-Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended
fi

# Link ZSH theme to OMZSH custom theme dir
if [ -d "$HOME/.oh-my-zsh" ]; then
    ZSH_CUSTOM_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
    ensure_dir "$ZSH_CUSTOM_DIR/themes"
    safe_symlink "$SYNCBIN/zsh/theme/jemus42.zsh-theme" "$ZSH_CUSTOM_DIR/themes/jemus42.zsh-theme"
fi

echo

#########################
## Tmux Plugin Manager ##
#########################
echo "🔌 Setting up Tmux Plugin Manager..."

if [ ! -d "$HOME/.config/tmux/plugins/tpm" ]; then
    echo "Installing TPM..."
    git clone --depth 1 --single-branch https://github.com/tmux-plugins/tpm "$HOME/.config/tmux/plugins/tpm" &
fi

echo

#########################
## Submodules update   ##
#########################
echo "📦 Updating git submodules..."

if [ -d "$SYNCBIN/.git" ]; then
    git -C "$SYNCBIN" submodule update --init --recursive
else
    echo "⚠ Not a git repository, skipping submodule update"
fi

echo

#########################
## Cleanup legacy      ##
#########################
echo "🧹 Cleaning up legacy configurations..."

# Remove old zellij config format
[ -f "$HOME/.config/zellij/config.yml" ] && rm "$HOME/.config/zellij/config.yml"

echo

#########################
## Completion          ##
#########################
echo "✅ Installation complete!"
echo
echo "📋 Next steps:"
echo "   • Restart your terminal or run: source ~/.zshrc (for zsh) or source ~/.bash_profile (for bash)"
echo "   • Install additional tools as needed (starship, bat, lsd, etc.)"
echo "   • Customize local settings in ~/.env.local, ~/.path.local, or ~/.functions.local"
echo
echo "🔗 Shell configurations available:"
echo "   • ZSH: ~/.zshrc → $SYNCBIN/zsh/zshrc.zsh"
echo "   • Bash: ~/.bashrc → $SYNCBIN/bash/bashrc (main config)"
echo "   •       ~/.bash_profile → $SYNCBIN/bash/bash_profile (sources .bashrc)"
echo "   • Fish: ~/.config/fish/config.fish → $SYNCBIN/fish/config.fish"
echo