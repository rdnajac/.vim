#!/bin/sh

# Directories
INSTALL_DIR="$HOME/.neovim"
LOCALBIN="$HOME/.local/bin"
ASSET="nvim-macos-arm64.tar.gz"
TARPATH="/tmp/$ASSET"
TAR_BASE="https://github.com/neovim/neovim/releases/download/nightly"

# Create directories
mkdir -p "$INSTALL_DIR" "$LOCALBIN"

# Download nightly
echo "→ Downloading Neovim nightly..."
curl -L "$TAR_BASE/$ASSET" -o "$TARPATH" || { echo "Download failed"; exit 1; }

# Extract
echo "→ Installing..."
rm -rf "$INSTALL_DIR/bin" "$INSTALL_DIR/lib" "$INSTALL_DIR/share"
tar -xzf "$TARPATH" -C "$INSTALL_DIR" --strip-components=1

# Symlink
ln -sf "$INSTALL_DIR/bin/nvim" "$LOCALBIN/nvim"

# Clean up
rm -f "$TARPATH"

# Verify
"$LOCALBIN/nvim" --version

echo "✅ Neovim installed to $LOCALBIN/nvim"
