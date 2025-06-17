" better format automatic foldmarkers with `zf`
setlocal commentstring=\ \"\ %s
setlocal foldmethod=marker
setlocal iskeyword-=#

imap <M-Up> <Up>
imap <M-Down> <Down>
imap <M-Left> <Left>
imap <M-Right> <Right>

setlocal foldtext=fold#text()

if has('nvim')
  lua vim.treesitter.start()
endif
