" briefly highlight copied text
if !has('nvim')
  set clipboard=unnamed
  packadd hlyank
else
  augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
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

  augroup BackupClipboard
    autocmd!
    autocmd TextYankPost * ++once call s:setup_clipboard()
  augroup END
endif
