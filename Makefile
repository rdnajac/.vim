.PHONY: fmt update

fmt:
	@echo "Formatting code..."
	stylua -v .

update:
	@echo "Updating neovim..."
	./bin/nv-update-nightly
