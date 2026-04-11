# My (n)vim config

## PATHS

### $MYVIMDIR

repo works with vim when placed in `~/.vim/`
and with neovim when placed in `~/.config/nvim/`

### `$VIMRUNTIME`

@~/neovim/share/nvim/runtime/E5108: Lua: /Users/rdn/.config/nvim/lua/munchies/pickers.lua:92: attempt to call method 'refresh' (a nil value)
stack traceback:
	/Users/rdn/.config/nvim/lua/munchies/pickers.lua:92: in function </Users/rdn/.config/nvim/lua/munchies/pickers.lua:85>


- `~/neovim/share/nvim/runtime/` - remember this!
- `~/neovim/share/nvim/runtime/doc/` - read these!
- `~/neovim/share/nvim/runtime/lua/vim` - code here!

### $PACKDIR

- `~/.local/share/nvim/site/pack/core/opt/` - neovim's `vim.pack` module
-  `$MYVIMDIR/pack/` - my managed plugins
-  `$MYVIMDIR/pack/jetpack` - jetpack plugins ($PACKDIR if vim)

## RULES

- always consult the local documentation first
