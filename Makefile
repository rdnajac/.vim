.PHONY: fmt update get-vimtips compile-vimtips act install-neovim profile

fmt:
	@echo "Formatting code..."
	stylua -v .

update:
	@echo "Updating neovim..."
	(cd ~/GitHub/neovim/ && make update)

profile:
	nvim -c 'set rtp+=/Users/rdn/.local/share/nvim/site/pack/core/opt/snacks.nvim' -c 'lua require("snacks.profiler").startup({ startup = { event = "UIEnter" } })'

act:
	./bin/scripts/act

install-neovim:
	./bin/scripts/install-neovim.sh
