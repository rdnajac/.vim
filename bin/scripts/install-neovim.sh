#!/bin/sh

die() {
	printf "%s\n" "$1"
	exit "${2:-1}"
}

# Detect OS
case "$(uname -s)" in
Darwin) OS_NAME="macos" ;;
Linux) OS_NAME="linux" ;;
*) die "Unsupported OS: $(uname -s)" ;;
esac

# Detect architecture
case "$(uname -m)" in
x86_64) ARCH_NAME="x86_64" ;;
arm64 | aarch64) ARCH_NAME="arm64" ;;
*) die "Unsupported architecture: $(uname -m)" ;;
esac

# Determine asset
ASSET="nvim-${OS_NAME}-${ARCH_NAME}.tar.gz"
TARPATH="/tmp/$ASSET"
TAR_BASE="https://github.com/neovim/neovim/releases/download/nightly"

# Install directories
INSTALL_DIR="$HOME/.${ASSET%.tar.gz}"
LOCALBIN="$HOME/.local/bin"

# Prepare directories
rm -rf "$INSTALL_DIR"
mkdir -p "$INSTALL_DIR" "$LOCALBIN"

printf "→ Downloading Neovim nightly (%s)...\n" "$ASSET"
curl -L "$TAR_BASE/$ASSET" -o "$TARPATH" || die "Download failed"

printf "→ Installing Neovim...\n"
tar -xzf "$TARPATH" -C "$INSTALL_DIR" --strip-components=1 || die "Extraction failed"

ln -sf "$INSTALL_DIR/bin/nvim" "$LOCALBIN/nvim" || die "Failed to link nvim to $LOCALBIN"

rm -f "$TARPATH"

"$LOCALBIN/nvim" --version || die "Neovim failed to run"

printf "neovim nightly installed!\n"
