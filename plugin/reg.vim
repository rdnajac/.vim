" yank/delete everything
nnoremap yY <Cmd>%y<CR>
nnoremap dD <Cmd>%d<CR>

nnoremap dy "_dd
" vnoremap <silent> dy "_dP
" vnoremap <silent> yp p"_d

" yank path
nnoremap yp <Cmd>let @*=expand('%:p:~')<CR>

if !has('nvim')
  set clipboard=unnamed
  packadd hlyank
else
  augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua vim.hl.on_yank()
  augroup END

  function s:setup_clipboard()
    if &clipboard == ''
      " map default yank to system clipboard
      nnoremap <expr> y v:register == '"' ? '"+y' : 'y'
      vnoremap <expr> y v:register == '"' ? '"+y' : 'y'
      " copy the last yanked text to the system clipboard
      silent let @+ = getreg('"')
    endif
  endfunction

  " TODO: ~/.local/neovim/share/nvim/runtime/plugin/osc52.lua
  augroup BackupClipboard
    autocmd!
    " Setup unnamedplus clipboard on first yank if
    " the system clipboard is not not already setup
    autocmd TextYankPost * ++once call s:setup_clipboard()
  augroup END
endif
