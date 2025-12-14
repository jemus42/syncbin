#!/bin/sh

# Syncbin bootstrap script
# One-line install: curl -fsSL https://raw.githubusercontent.com/jemus42/syncbin/main/bootstrap.sh | sh
# Interactive mode: curl -fsSL ... | sh -s -- -i

set -e

# Defaults
SYNCBIN_DIR="${SYNCBIN:-$HOME/syncbin}"
REPO_URL="https://github.com/jemus42/syncbin.git"
BRANCH="main"
AUTO_YES="-y"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() {
    printf "${1}%s${NC}\n" "$2"
}

usage() {
    cat <<EOF
Usage: bootstrap.sh [OPTIONS]

Bootstrap syncbin dotfiles installation.

Options:
  -d, --dir DIR       Install to DIR (default: ~/syncbin or \$SYNCBIN)
  -b, --branch BR     Clone branch BR (default: main)
  -i, --interactive   Run install.sh interactively (prompt for each step)
  -h, --help          Show this help message

Examples:
  # Default install (non-interactive)
  curl -fsSL https://raw.githubusercontent.com/jemus42/syncbin/main/bootstrap.sh | sh

  # Interactive install (prompts for confirmation)
  curl -fsSL ... | sh -s -- -i

  # Install to custom directory
  curl -fsSL ... | sh -s -- -d ~/.dotfiles
EOF
    exit 0
}

# Parse arguments
while [ $# -gt 0 ]; do
    case "$1" in
        -d|--dir)
            SYNCBIN_DIR="$2"
            shift 2
            ;;
        -b|--branch)
            BRANCH="$2"
            shift 2
            ;;
        -i|--interactive)
            AUTO_YES=""
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            print_status "$RED" "Unknown option: $1"
            usage
            ;;
    esac
done

# Check for git
if ! command -v git >/dev/null 2>&1; then
    print_status "$RED" "Error: git is required but not installed."
    exit 1
fi

print_status "$BLUE" "======================================"
print_status "$BLUE" "     Syncbin Bootstrap                "
print_status "$BLUE" "======================================"
echo
print_status "$GREEN" "Target directory: $SYNCBIN_DIR"
print_status "$GREEN" "Branch: $BRANCH"
echo

# Clone or update repo
if [ -d "$SYNCBIN_DIR/.git" ]; then
    print_status "$YELLOW" "Syncbin already exists at $SYNCBIN_DIR"
    print_status "$BLUE" "Pulling latest changes..."
    git -C "$SYNCBIN_DIR" pull --ff-only origin "$BRANCH" || {
        print_status "$YELLOW" "Pull failed, continuing with existing version"
    }
else
    if [ -e "$SYNCBIN_DIR" ]; then
        print_status "$RED" "Error: $SYNCBIN_DIR exists but is not a git repository"
        print_status "$RED" "Please remove or rename it first"
        exit 1
    fi
    print_status "$BLUE" "Cloning syncbin to $SYNCBIN_DIR..."
    git clone --depth 1 --branch "$BRANCH" "$REPO_URL" "$SYNCBIN_DIR"
fi

# Run install script
print_status "$BLUE" "Running install script..."
echo

export SYNCBIN="$SYNCBIN_DIR"
if [ -n "$AUTO_YES" ]; then
    exec "$SYNCBIN_DIR/install.sh" -y
else
    exec "$SYNCBIN_DIR/install.sh"
fi
