" yank/delete everything
nnoremap yY <Cmd>%y<CR>
nnoremap dD <Cmd>%d<CR>

" delete/paste without yanking
nnoremap dy "_dd
vnoremap p "_dP
vnoremap <leader>c "_c
vnoremap <leader>d "_d

" yank path current file path, with and without line number
nnoremap yp <Cmd>let @*=expand('%:p:~')<CR>
nnoremap yP <Cmd>let @*=printf('%s:%d', expand('%:p:~'), line('.'))<CR>
cnoremap <M-y> <Cmd>let @*=getcmdline()<CR>

" 'change macro'
nnoremap cm :<C-u><C-r><C-r>="let @q = " . string(getreg('q'))<CR>
nnoremap cM :<C-u><C-r><C-r>="let @". v:register ." = ". string(getreg(v:register))<CR><Left>

function s:set_clipboard() abort
  if !has('nvim')
    set clipboard=unnamed
  else
    if !exists('$SSH_TTY') " don't set clipboard over ssh
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

function! s:yankring() abort
  if v:event.operator ==# 'y'
    " call map(range(9, 1, -1), {_, i -> setreg(string(i), getreg(string(i-1)))})
    for i in range(9, 1, -1)
      call setreg(string(i), getreg(string(i - 1)))
    endfor
  endif
endfunction

augroup vimrc_yank
  autocmd!
  autocmd TextYankPost * call s:yankring()
  " Setup unnamedplus clipboard on first yank if the system clipboard is not not already setup
  autocmd TextYankPost * ++once call s:fallback()
  if has('nvim')
    autocmd TextYankPost * silent! lua vim.hl.on_yank()
    " autocmd TextYankPost * silent! lua vim.hl.on_yank {higroup='Visual', timeout=300}
    autocmd UIEnter * call s:set_clipboard()
  endif
augroup END

if has('nvim')
  nnoremap yu <Cmd>lua require('nvim.util.debug.printval')()<CR>
  if luaeval('package.loaded["which-key"] ~= nil')
    lua vim.schedule(function() require('which-key.plugins.registers').registers = [[*+"-:.%/#=_0123456789]] end)
  endif
endif
