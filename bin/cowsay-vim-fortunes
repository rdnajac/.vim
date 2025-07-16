#!/usr/bin/env bash

indent="          "

fortune=~/.vim/fortunes/learn-something

{
	"$fortune" | cowsay | sed "s/^/$indent/"
	printf "\n"
	cat << 'EOF'
  The computing scientist's main challenge is not to get
      confused by the complexities of his own making.
EOF
} | lolcat
