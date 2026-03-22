default:	
  just --list

fmt:
  stylua -v .

update:
  cd ~/GitHub/neovim/ && make update

upgrade:
  nvim -c 'lua vim.pack.update()'

profile:
  nvim -c 'set rtp+=/Users/rdn/.local/share/nvim/site/pack/core/opt/snacks.nvim' \
    -c 'lua require("snacks.profiler").startup({startup={event="UIEnter"}})'

act:
  ./bin/scripts/act

install-neovim:
  ./bin/scripts/install-neovim.sh
