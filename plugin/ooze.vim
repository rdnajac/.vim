if !has('nvim')
  finish
endif
let g:loaded_ooze = 1

if !exists('g:ooze_auto_advance')  | let g:ooze_auto_advance  = 1 | endif
if !exists('g:ooze_auto_scroll')   | let g:ooze_auto_scroll   = 1 | endif
if !exists('g:ooze_auto_exec')     | let g:ooze_auto_exec     = 1 | endif
if !exists('g:ooze_skip_comments') | let g:ooze_skip_comments = 1 | endif
if !exists('g:ooze_cr') | let g:ooze_cr = 1 | endif

" nnoremap <leader><CR> <Cmd>call ooze#init()<CR>
nnoremap <M-CR> <Cmd>call ooze#file()<CR>
nnoremap <expr> <CR> ooze#line() > 0 ? '' : "\<CR>"

augroup ooze
  autocmd!
  autocmd TermOpen * let g:ooze_channel = &channel
  autocmd TermOpen * let g:ooze_buffer = bufnr('%')
  " autocmd Filetype vim,lua nnoremap <buffer> <CR> <Cmd>call CRooze()<CR>
  " autocmd Filetype r,rmd nnoremap <buffer> <CR> <Cmd>call ooze#send(getline('.'))<CR>
  " autocmd Filetype vim,lua nnoremap <buffer> <CR> <Cmd>call ooze#send()<CR>
  " autocmd TermClose * unlet! g:ooze_channel
augroup END

" NOTE: (neovim) support for editing encrypted files has been removed
command! -nargs=+ X call append('$', Append(<f-args>))
" WARN: (vim only) E841: Reserved name, cannot be used for user defined command
command! -nargs=+ Append call append('$', Append(<f-args>))

function! XCmdline() abort
  let cmdline = getcmdline()
  if empty(cmdline) || getcmdtype()  != ':'
    return '<M-CR>'
  else
    call feedkeys("\<C-c>", 'n') " cancel cmdline
    call timer_start(0, {-> execute('call redir#execute("' . escape(cmdline, '"') . '")')})
  endif
endfunction

cnoremap <expr> <M-CR> XCmdline()
