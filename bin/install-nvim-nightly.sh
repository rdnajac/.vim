#!/bin/bash
## Install `neovim` nightly build for ARM64 on macOS.

set -eu

URL="https://github.com/neovim/neovim/releases/download/nightly/nvim-macos-arm64.tar.gz"
TARBALL="${URL##*/}"
INSTALL_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/nvim"
BIN_DIR="$HOME/.local/bin"

mkdir -p "$INSTALL_DIR" "$BIN_DIR"

nvim_version() {
	command -v nvim > /dev/null 2>&1 && nvim --version | awk 'NR==1 { print $2 }' || echo ""
}

if [[ "$(nvim_version)" != "" ]]; then
	echo "👾 Updating Neovim nightly (ARM64)..."
else
	echo "👾 Installing Neovim nightly (ARM64)..."
fi

curl -L "$URL" -o "$TARBALL"
xattr -c "$TARBALL"
rm -rf "$INSTALL_DIR/runtime"
tar -xzf "$TARBALL" -C "$INSTALL_DIR" --strip-components=1
ln -sf "$INSTALL_DIR/bin/nvim" "$BIN_DIR/nvim"
rm "$TARBALL"

echo "✅ Neovim nightly $(nvim_version) installed successfully!"
