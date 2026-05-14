#!/bin/sh

# Syncbin installation script
# Portable shell script for setting up dotfiles and configurations
# Compatible with sh, bash, zsh, and other POSIX shells

set -e  # Exit on any error

# Track backup files created during this run
BACKUP_FILES=""

# Parse arguments
AUTO_YES=""
while [ $# -gt 0 ]; do
    case "$1" in
        -y|--yes)
            AUTO_YES=1
            shift
            ;;
        -h|--help)
            echo "Usage: install.sh [-y|--yes] [--unstow] [-h|--help]"
            echo "  -y, --yes   Accept all defaults (non-interactive)"
            echo "  --unstow    Remove all stowed symlinks"
            echo "  -h, --help  Show this help"
            exit 0
            ;;
        --unstow)
            UNSTOW=1
            shift
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

# Check for stow
if ! command -v stow >/dev/null 2>&1; then
    printf "${RED}GNU stow is required but not installed.${NC}\n"
    case "$OS_TYPE" in
        macos)  echo "  Install: brew install stow" ;;
        linux)  echo "  Install: apt install stow  OR  dnf install stow" ;;
    esac
    exit 1
fi

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
        BACKUP_FILES="$BACKUP_FILES
$backup"
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

# Stow a package from packages/ into $HOME
stow_package() {
    local pkg="$1"
    local pkg_dir="$SYNCBIN/packages/$pkg"
    if [ ! -d "$pkg_dir" ]; then
        print_status "$YELLOW" "⚠ Package not found: $pkg"
        return 0
    fi
    # Dry-run to detect conflicts
    local conflicts
    conflicts=$(stow -d "$SYNCBIN/packages" -t "$HOME" -n "$pkg" 2>&1 | grep "existing target is" || true)
    if [ -n "$conflicts" ]; then
        print_status "$YELLOW" "! Conflicts detected for $pkg:"
        echo "$conflicts" | while IFS= read -r line; do
            local target
            target=$(echo "$line" | sed 's/.*existing target is neither a link nor a directory: //')
            if [ -n "$target" ] && [ -e "$HOME/$target" ]; then
                if prompt_user "  Back up and replace $HOME/$target?"; then
                    create_backup "$HOME/$target"
                else
                    print_status "$YELLOW" "  ⚠ Skipped: $target"
                fi
            fi
        done
    fi
    if stow -d "$SYNCBIN/packages" -t "$HOME" "$pkg" 2>/dev/null; then
        print_status "$GREEN" "✓ Stowed: $pkg"
    else
        print_status "$RED" "✗ Failed to stow: $pkg"
        return 1
    fi
}

# Unstow a package
unstow_package() {
    local pkg="$1"
    stow -d "$SYNCBIN/packages" -t "$HOME" -D "$pkg" 2>/dev/null
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

# Handle unstow
if [ "$UNSTOW" = 1 ]; then
    print_status "$BLUE" "Unstowing all packages..."
    for pkg in shell prompt bin bat btop zellij tmux helix micro broot conda lsd carapace claude r; do
        unstow_package "$pkg"
    done
    if [ "$OS_TYPE" = "macos" ]; then
        for pkg in alacritty ghostty zed; do
            unstow_package "$pkg"
        done
    fi
    print_status "$GREEN" "All packages unstowed."
    exit 0
fi

#########################
## Create directories  ##
#########################
print_status "$BLUE" "📁 Creating configuration directories..."

ensure_dir "$HOME/.config"
ensure_dir "$HOME/.local/bin"
ensure_dir "$HOME/.config/syncbin"  # Local overrides directory

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

echo

#########################
## Stow packages       ##
#########################
print_status "$BLUE" "📦 Stowing configuration packages..."

# Core packages (all platforms)
for pkg in shell prompt bin bat btop zellij tmux helix micro broot conda lsd carapace claude r; do
    stow_package "$pkg"
done

echo

#########################
## Platform-specific   ##
#########################
if [ "$OS_TYPE" = "macos" ]; then
    print_status "$BLUE" "🍎 Stowing macOS-specific packages..."
    for pkg in alacritty ghostty zed; do
        stow_package "$pkg"
    done
    echo
fi

#########################
## Post-stow hooks     ##
#########################
print_status "$BLUE" "🔧 Running post-stow hooks..."

# macOS: arf.toml lives at ~/Library/Application Support/arf/
if [ "$OS_TYPE" = "macos" ]; then
    arf_xdg="$HOME/.config/arf/arf.toml"
    arf_macos_dir="$HOME/Library/Application Support/arf"
    if [ -L "$arf_xdg" ]; then
        ensure_dir "$arf_macos_dir"
        mv "$arf_xdg" "$arf_macos_dir/arf.toml"
        rmdir "$HOME/.config/arf" 2>/dev/null
        print_status "$GREEN" "✓ Moved arf.toml symlink to macOS location"
    fi
fi

# Claude Code: patch statusline into settings.json
if command -v jq >/dev/null 2>&1; then
    settings_file="$HOME/.claude/settings.json"
    statusline_cmd="bash \"$SYNCBIN/claude/statusline.sh\""
    if [ -f "$settings_file" ]; then
        tmp=$(mktemp)
        if jq --arg cmd "$statusline_cmd" '.statusLine = {"type": "command", "command": $cmd, "refreshInterval": 5}' \
            "$settings_file" > "$tmp" 2>/dev/null; then
            mv "$tmp" "$settings_file"
            print_status "$GREEN" "✓ Patched statusline in settings.json"
        else
            rm -f "$tmp"
            print_status "$YELLOW" "⚠ Failed to patch statusline (jq error)"
        fi
    else
        printf '{"statusLine":{"type":"command","command":"%s","refreshInterval":5}}\n' "$statusline_cmd" > "$settings_file"
        print_status "$GREEN" "✓ Created settings.json with statusline"
    fi
else
    print_status "$YELLOW" "⚠ jq not found — skipping statusline patch (install jq to enable)"
fi

# RStudio themes (conditional)
if [ -d "$HOME/.config/rstudio/themes/" ] && [ -d "$SYNCBIN/rstudio/themes" ]; then
    print_status "$BLUE" "📈 Installing RStudio themes..."
    for theme in "$SYNCBIN/rstudio/themes"/*.rstheme; do
        if [ -f "$theme" ]; then
            safe_symlink "$theme" "$HOME/.config/rstudio/themes/$(basename "$theme")"
        fi
    done
fi

echo

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

# Replace btop.conf symlink with a regular file
if [ -L "$HOME/.config/btop/btop.conf" ]; then
    btop_target="$(readlink "$HOME/.config/btop/btop.conf")"
    case "$btop_target" in
        *syncbin*)
            if [ -f "$btop_target" ]; then
                # Symlink target still exists, copy content
                cp "$btop_target" "$HOME/.config/btop/btop.conf.tmp"
                rm "$HOME/.config/btop/btop.conf"
                mv "$HOME/.config/btop/btop.conf.tmp" "$HOME/.config/btop/btop.conf"
                print_status "$GREEN" "✓ Converted btop.conf symlink to regular file"
            else
                # Symlink target is gone, just remove the dangling symlink
                rm "$HOME/.config/btop/btop.conf"
                print_status "$YELLOW" "⚠ Removed dangling btop.conf symlink"
            fi
            ;;
    esac
fi

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
echo "   • Unstow individual packages: install.sh --unstow"
echo
print_status "$BLUE" "🔗 Packages stowed via GNU stow:"
echo "   • shell: ~/.zshrc, ~/.bashrc, ~/.config/fish/, ~/.config/zsh/, ~/.config/bash/"
echo "   • prompt: ~/.config/starship.toml"
echo "   • bin: ~/.local/bin/*"
echo "   • Tools: bat, btop, zellij, tmux, helix, micro, broot, conda, lsd, carapace"
echo "   • claude: ~/.claude/CLAUDE.md, ~/.claude/skills/"
echo "   • r: ~/.Rprofile, ~/.config/arf/"
if [ "$OS_TYPE" = "macos" ]; then
    echo "   • macOS: alacritty, ghostty, zed"
fi
echo

# Report backup files created during this run
if [ -n "$BACKUP_FILES" ]; then
    echo
    print_status "$YELLOW" "📦 Backup files were created:"
    echo "$BACKUP_FILES" | while IFS= read -r f; do
        [ -n "$f" ] && echo "   $f"
    done
    echo
fi