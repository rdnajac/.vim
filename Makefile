.PHONY: fmt update get-vimtips compile-vimtips act install-neovim

fmt:
	@echo "Formatting code..."
	stylua -v .

update:
	@echo "Updating neovim..."
	./bin/nv-update-nightly

get-vimtips:
	wget https://raw.githubusercontent.com/openuado/vimtips-fortune/refs/heads/master/fortunes/vimtips

compile-vimtips:
	strfile -c % ./vimtips vimtips.dat

act:
	./bin/scripts/act

install-neovim:
	./bin/scripts/install-neovim.sh
