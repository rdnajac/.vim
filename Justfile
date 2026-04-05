default:
  just --list

fmt:
  stylua -v .

update:
  cd ~/GitHub/neovim/ && make update

upgrade:
  nvim -c 'lua vim.pack.update()'
  # nvim --headless -c 'lua vim.pack.update(nil, {force=true})' -c 'q'

profile *args:
  nvim -c 'set rtp+=/Users/rdn/.local/share/nvim/site/pack/core/opt/snacks.nvim' \
       -c 'lua require("snacks.profiler").startup({startup={event="UIEnter"}, presets={startup={min_time=0.5}}})' {{args}}

act:
  act -P ubuntu-latest=ghcr.io/catthehacker/ubuntu:full-latest --container-architecture linux/amd64

install-neovim:
  ./bin/scripts/install-neovim.sh
