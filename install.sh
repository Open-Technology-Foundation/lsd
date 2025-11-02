#!/usr/bin/env bash
#shellcheck disable=SC2317
set -Eeuo pipefail

# lsd - Quick Installation Script
# Part of the Okusi Group file utilities
# Repository: https://github.com/Open-Technology-Foundation/lsd

# Configuration
readonly REPO_URL="https://github.com/Open-Technology-Foundation/lsd.git"
readonly INSTALL_DIR="/tmp/lsd-install-$$"
readonly PREFIX="${PREFIX:-/usr/local}"

# Colors and icons
readonly ICON_INFO="◉"
readonly ICON_SUCCESS="✓"
readonly ICON_ERROR="✗"

# Cleanup on exit
cleanup() {
  if [[ -d "$INSTALL_DIR" ]]; then
    rm -rf "$INSTALL_DIR"
  fi
}
trap cleanup EXIT

# Error handler
error_exit() {
  echo "$ICON_ERROR Error: $1" >&2
  exit 1
}

# Check if running as root
check_root() {
  if [[ $EUID -ne 0 ]]; then
    error_exit "This script must be run as root (use sudo)"
  fi
}

# Check dependencies
check_dependencies() {
  echo "$ICON_INFO Checking dependencies..."

  local -a missing_deps=()

  command -v git >/dev/null 2>&1 || missing_deps+=("git")
  command -v make >/dev/null 2>&1 || missing_deps+=("make")
  command -v tree >/dev/null 2>&1 || missing_deps+=("tree")

  if [[ ${#missing_deps[@]} -gt 0 ]]; then
    echo "$ICON_ERROR Missing dependencies: ${missing_deps[*]}" >&2
    echo "" >&2
    echo "Install them with:" >&2
    echo "  sudo apt install ${missing_deps[*]}" >&2
    exit 1
  fi

  echo "$ICON_SUCCESS All dependencies satisfied"
}

# Clone repository
clone_repo() {
  echo "$ICON_INFO Cloning repository..."
  git clone --quiet --depth=1 "$REPO_URL" "$INSTALL_DIR" 2>/dev/null || \
    error_exit "Failed to clone repository"
  echo "$ICON_SUCCESS Repository cloned"
}

# Install using Makefile
install_lsd() {
  echo "$ICON_INFO Installing lsd to $PREFIX..."

  cd "$INSTALL_DIR" || error_exit "Failed to change directory"

  make PREFIX="$PREFIX" install 2>&1 | grep -E "^(◉|✓|✗)" || true

  if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    error_exit "Installation failed"
  fi
}

# Main installation
main() {
  echo ""
  echo "lsd - List Directory Tree"
  echo "=========================="
  echo ""

  check_root
  check_dependencies
  clone_repo
  install_lsd

  echo ""
  echo "$ICON_SUCCESS Installation complete!"
  echo ""
  echo "Usage:"
  echo "  lsd              # List current directory"
  echo "  lsd -3 /var      # List /var, 3 levels deep"
  echo "  lsd -A /etc      # All files with detailed listing"
  echo "  man lsd          # View manual page"
  echo ""
  echo "To enable bash completion, start a new shell or run:"
  echo "  source $PREFIX/share/bash-completion/completions/lsd"
  echo ""
}

main "$@"

#fin
