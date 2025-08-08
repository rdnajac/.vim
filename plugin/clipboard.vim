function s:set_clipboard() abort
  if !has('nvim')
    set clipboard=unnamed
  else
    " don't use the clipboard over ssh
    if !exists('$SSH_TTY')
      set clipboard=unnamedplus
    endif
  endif
endfunction

function s:fallback() abort
  if empty(&clipboard)
    " map default yank to system clipboard
    nnoremap <expr> y v:register == '"' ? '"+y' : 'y'
    vnoremap <expr> y v:register == '"' ? '"+y' : 'y'
    " copy the last yanked text to the system clipboard
    silent let @+ = getreg('"')
  endif
endfunction

" TODO: ~/.local/neovim/share/nvim/runtime/plugin/osc52.lua
augroup Clipboard
  autocmd!
  " FIXME: this is only in nvim
  autocmd UIEnter * call s:set_clipboard()
  " Setup unnamedplus clipboard on first yank if
  " the system clipboard is not not already setup
  autocmd TextYankPost * ++once call s:fallback()
augroup END
