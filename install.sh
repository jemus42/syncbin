#!/bin/sh

# Syncbin installation script
# Portable shell script for setting up dotfiles and configurations
# Compatible with sh, bash, zsh, and other POSIX shells

set -e  # Exit on any error

# Parse arguments
AUTO_YES=""
while [ $# -gt 0 ]; do
    case "$1" in
        -y|--yes)
            AUTO_YES=1
            shift
            ;;
        -h|--help)
            echo "Usage: install.sh [-y|--yes] [-h|--help]"
            echo "  -y, --yes   Accept all defaults (non-interactive)"
            echo "  -h, --help  Show this help"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

# Helper function for colored output
print_status() {
    local color=$1
    local message=$2
    printf "${color}%s${NC}\n" "$message"
}

# Helper function to prompt user
prompt_user() {
    local message=$1
    local response

    # Auto-accept in non-interactive mode
    if [ -n "$AUTO_YES" ]; then
        printf "${YELLOW}%s (y/N): ${GREEN}y (auto)${NC}\n" "$message"
        return 0
    fi

    printf "${YELLOW}%s (y/N): ${NC}" "$message"
    read -r response

    case "$response" in
        [yY][eE][sS]|[yY]) return 0 ;;
        *) return 1 ;;
    esac
}

# Helper function to create backup
create_backup() {
    local file=$1
    local backup="${file}.backup.$(date +%Y%m%d_%H%M%S)"
    
    if mv "$file" "$backup"; then
        print_status "$GREEN" "✓ Created backup: $backup"
        return 0
    else
        print_status "$RED" "✗ Failed to create backup of $file"
        return 1
    fi
}

# Helper function to create directory if it doesn't exist
ensure_dir() {
    local dir=$1
    
    if [ ! -d "$dir" ]; then
        if mkdir -p "$dir"; then
            print_status "$GREEN" "✓ Created directory: $dir"
        else
            print_status "$RED" "✗ Failed to create directory: $dir"
            return 1
        fi
    fi
}

# Enhanced symlink function with user interaction
safe_symlink() {
    local src="$1"
    local dest="$2"
    local backup_created=0
    
    # Check if source exists
    if [ ! -e "$src" ] && [ ! -L "$src" ]; then
        print_status "$RED" "✗ Source not found: $src"
        return 1
    fi
    
    # If destination exists and is not a symlink to our source
    if [ -e "$dest" ] || [ -L "$dest" ]; then
        # Check if it's already the correct symlink
        if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
            print_status "$BLUE" "○ Already linked: $dest → $src"
            return 0
        fi
        
        # Ask user what to do
        print_status "$YELLOW" "! File exists: $dest"
        if prompt_user "Replace with symlink to $src?"; then
            if [ -e "$dest" ] && [ ! -L "$dest" ]; then
                # It's a real file/directory, create backup
                if create_backup "$dest"; then
                    backup_created=1
                else
                    return 1
                fi
            else
                # It's a symlink, just remove it
                rm -f "$dest"
            fi
        else
            print_status "$YELLOW" "⚠ Skipped: $dest"
            return 0
        fi
    fi
    
    # Create the symlink
    if ln -sf "$src" "$dest"; then
        print_status "$GREEN" "✓ Linked: $dest → $src"
    else
        print_status "$RED" "✗ Failed to create symlink: $dest"
        # Restore backup if we created one
        if [ $backup_created -eq 1 ]; then
            local backup="${dest}.backup.$(date +%Y%m%d_%H%M%S)"
            mv "$backup" "$dest"
            print_status "$YELLOW" "⚠ Restored original file"
        fi
        return 1
    fi
}

# Helper function to create symlink only if destination doesn't exist
safe_symlink_if_missing() {
    local src="$1"
    local dest="$2"
    
    if [ ! -e "$dest" ] && [ ! -L "$dest" ]; then
        if [ -f "$src" ] || [ -d "$src" ]; then
            if ln -sf "$src" "$dest"; then
                print_status "$GREEN" "✓ Linked: $dest → $src"
            else
                print_status "$RED" "✗ Failed to create symlink: $dest"
                return 1
            fi
        else
            print_status "$RED" "✗ Source not found: $src"
            return 1
        fi
    else
        print_status "$BLUE" "○ Already exists: $dest"
    fi
}

# Introduction
echo
print_status "$BLUE" "======================================"
print_status "$BLUE" "     Syncbin Installation Script      "
print_status "$BLUE" "======================================"
echo
print_status "$GREEN" "📂 SYNCBIN: $SYNCBIN"
print_status "$GREEN" "🖥️  OS: $OS_TYPE"
echo

# Confirmation prompt
if [ -z "$AUTO_YES" ]; then
    if ! prompt_user "This will set up dotfiles and configurations. Continue?"; then
        print_status "$YELLOW" "Installation cancelled."
        exit 0
    fi
else
    print_status "$GREEN" "Running in non-interactive mode (-y)"
fi

echo
print_status "$BLUE" "Starting installation..."
echo

#########################
## Create directories  ##
#########################
print_status "$BLUE" "📁 Creating configuration directories..."

# Standard config directories
ensure_dir "$HOME/.config/zsh"
ensure_dir "$HOME/.config/fish"
ensure_dir "$HOME/.config/syncbin"  # Local overrides directory
ensure_dir "$HOME/.config/broot"
ensure_dir "$HOME/.config/conda"
ensure_dir "$HOME/.config/zellij"
ensure_dir "$HOME/.config/lsd"
ensure_dir "$HOME/.config/micro"
ensure_dir "$HOME/.config/btop"
ensure_dir "$HOME/.config/bat"
ensure_dir "$HOME/.config/tmux"
ensure_dir "$HOME/.config/tmux/plugins"
ensure_dir "$HOME/.config/carapace"

# Platform-specific directories
if [ "$OS_TYPE" = "macos" ]; then
    ensure_dir "$HOME/.config/alacritty"
fi

echo

#########################
## Oh-My-Zsh setup     ##
#########################
# Install oh-my-zsh BEFORE shell symlinks, as it overwrites ~/.zshrc
print_status "$BLUE" "🔧 Setting up Oh-My-Zsh..."

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    if prompt_user "Oh-My-Zsh not found. Install it now?"; then
        print_status "$YELLOW" "Installing Oh-My-Zsh..."
        if sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended; then
            print_status "$GREEN" "✓ Oh-My-Zsh installed successfully"
            # Remove the default .zshrc that oh-my-zsh creates
            if [ -f "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ]; then
                rm -f "$HOME/.zshrc"
                print_status "$GREEN" "✓ Removed oh-my-zsh default .zshrc (will be replaced with symlink)"
            fi
        else
            print_status "$RED" "✗ Failed to install Oh-My-Zsh"
        fi
    else
        print_status "$YELLOW" "⚠ Skipped Oh-My-Zsh installation"
    fi
else
    print_status "$BLUE" "○ Oh-My-Zsh already installed"
fi

# Link ZSH theme to OMZSH custom theme dir
if [ -d "$HOME/.oh-my-zsh" ]; then
    ZSH_CUSTOM_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
    ensure_dir "$ZSH_CUSTOM_DIR/themes"
    safe_symlink "$SYNCBIN/zsh/theme/jemus42.zsh-theme" "$ZSH_CUSTOM_DIR/themes/jemus42.zsh-theme"
fi

echo

#########################
## Shell configurations ##
#########################
print_status "$BLUE" "🐚 Installing shell configurations..."

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
print_status "$BLUE" "⚙️  Installing core dotfiles..."

safe_symlink "$SYNCBIN/screenrc" "$HOME/.screenrc"
safe_symlink "$SYNCBIN/starship/starship.toml" "$HOME/.config/starship.toml"
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
print_status "$BLUE" "📊 Installing R configurations..."

safe_symlink "$SYNCBIN/R/Rprofile" "$HOME/.Rprofile"
safe_symlink "$SYNCBIN/R/radian_profile" "$HOME/.radian_profile"

echo

#########################
## Theme directories   ##
#########################
print_status "$BLUE" "🎨 Installing theme directories..."

safe_symlink_if_missing "$SYNCBIN/bat/themes" "$HOME/.config/bat/themes"
safe_symlink_if_missing "$SYNCBIN/btop/themes" "$HOME/.config/btop/themes"
safe_symlink_if_missing "$SYNCBIN/zellij/themes" "$HOME/.config/zellij/themes"
safe_symlink_if_missing "$SYNCBIN/helix" "$HOME/.config/helix"
safe_symlink_if_missing "$SYNCBIN/ghostty" "$HOME/.config/ghostty"
safe_symlink_if_missing "$SYNCBIN/micro/syntax" "$HOME/.config/micro/syntax"
safe_symlink_if_missing "$SYNCBIN/carapace/specs" "$HOME/.config/carapace/specs"

echo

#########################
## Platform-specific   ##
#########################
if [ "$OS_TYPE" = "macos" ]; then
    print_status "$BLUE" "🍎 Installing macOS-specific configurations..."
    
    safe_symlink "$SYNCBIN/alacritty/alacritty.yml" "$HOME/.config/alacritty/alacritty.yml"
    safe_symlink_if_missing "$SYNCBIN/zed" "$HOME/.config/zed"
    
    echo
fi

#########################
## RStudio themes      ##
#########################
if [ -d "$HOME/.config/rstudio/themes/" ]; then
    print_status "$BLUE" "📈 Installing RStudio themes..."
    for theme in "$SYNCBIN/rstudio/themes"/*.rstheme; do
        if [ -f "$theme" ]; then
            safe_symlink "$theme" "$HOME/.config/rstudio/themes/$(basename "$theme")"
        fi
    done
    echo
fi

#########################
## Tmux Plugin Manager ##
#########################
print_status "$BLUE" "🔌 Setting up Tmux Plugin Manager..."

if [ ! -d "$HOME/.config/tmux/plugins/tpm" ]; then
    if prompt_user "Tmux Plugin Manager not found. Install it now?"; then
        print_status "$YELLOW" "Installing TPM..."
        if git clone --depth 1 --single-branch https://github.com/tmux-plugins/tpm "$HOME/.config/tmux/plugins/tpm"; then
            print_status "$GREEN" "✓ TPM installed successfully"
        else
            print_status "$RED" "✗ Failed to install TPM"
        fi
    else
        print_status "$YELLOW" "⚠ Skipped TPM installation"
    fi
else
    print_status "$BLUE" "○ TPM already installed"
fi

echo

#########################
## Submodules update   ##
#########################
print_status "$BLUE" "📦 Updating git submodules..."

if [ -d "$SYNCBIN/.git" ]; then
    if git -C "$SYNCBIN" submodule update --init --recursive; then
        print_status "$GREEN" "✓ Submodules updated successfully"
    else
        print_status "$RED" "✗ Failed to update submodules"
    fi
else
    print_status "$YELLOW" "⚠ Not a git repository, skipping submodule update"
fi

echo

#########################
## Cleanup legacy      ##
#########################
print_status "$BLUE" "🧹 Cleaning up legacy configurations..."

# Remove old zellij config format
if [ -f "$HOME/.config/zellij/config.yml" ]; then
    if prompt_user "Remove old zellij config format (config.yml)?"; then
        if rm "$HOME/.config/zellij/config.yml"; then
            print_status "$GREEN" "✓ Removed old zellij config"
        else
            print_status "$RED" "✗ Failed to remove old zellij config"
        fi
    fi
fi

echo

#########################
## Summary             ##
#########################
print_status "$GREEN" "======================================"
print_status "$GREEN" "✅ Installation complete!"
print_status "$GREEN" "======================================"
echo
print_status "$BLUE" "📋 Next steps:"
echo "   • Restart your terminal or run:"
echo "     - For ZSH:  source ~/.zshrc"
echo "     - For Bash: source ~/.bashrc"
echo "     - For Fish: source ~/.config/fish/config.fish"
echo "   • Install additional tools as needed:"
echo "     - starship, bat, lsd, ripgrep, fzf, etc."
echo "   • Customize local settings in ~/.config/syncbin/:"
echo "     - env (environment variables), path (PATH additions)"
echo "     - *.zsh, *.bash, *.fish (shell-specific configs)"
echo
print_status "$BLUE" "🔗 Shell configurations installed:"
echo "   • ZSH:  ~/.zshrc → $SYNCBIN/zsh/zshrc.zsh"
echo "   • Bash: ~/.bashrc → $SYNCBIN/bash/bashrc (main config)"
echo "   •       ~/.bash_profile → $SYNCBIN/bash/bash_profile (sources .bashrc)"
echo "   • Fish: ~/.config/fish/config.fish → $SYNCBIN/fish/config.fish"
echo

# Check for any backup files created
if ls "$HOME"/*.backup.* >/dev/null 2>&1 || ls "$HOME"/.*.backup.* >/dev/null 2>&1; then
    echo
    print_status "$YELLOW" "📦 Backup files were created:"
    ls -la "$HOME"/*.backup.* "$HOME"/.*.backup.* 2>/dev/null | grep -v "^ls:"
    echo
fi