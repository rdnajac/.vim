default:
  just --list

fmt:
  stylua -v .

update:
  cd ~/GitHub/neovim/ && make update

upgrade:
  nvim -c 'lua vim.pack.update()'

profile *args:
  nvim -c 'set rtp+=/Users/rdn/.local/share/nvim/site/pack/core/opt/snacks.nvim' \
    -c 'lua require("snacks.profiler").startup({startup={event="UIEnter"}})' {{args}}

act:
  ./bin/scripts/act

install-neovim:
  ./bin/scripts/install-neovim.sh
