# xtras

## vimtips-fortune

Setup:

```Make
get-vimtips:
	wget https://raw.githubusercontent.com/openuado/vimtips-fortune/refs/heads/master/fortunes/vimtips

compile-vimtips:
	strfile -c % ./vimtips vimtips.dat

```

Run:

```sh
indent="          "

cd -P -- "$(dirname "$0")" || exit 1

{
	fortune ./tips/vimtips | cowsay | sed "s/^/$indent/"
	printf "\n"
	cat << 'EOF'
  The computing scientist's main challenge is not to get
      confused by the complexities of his own making.
EOF
} | lolcat
```

## neovim as a lua interpreter

For examples see 

- `:h -ll`
- `:h -lua-shebang`
- neovim/scripts/bump_deps.lua
- https://github.com/neovim/neovim/tree/master/src/gen
- ~/.local/share/nvim/site/pack/core/opt/nvim-treesitter/scripts/update-readme.lua

## Issues

- https://github.com/neovim/neovim/issues/37187
