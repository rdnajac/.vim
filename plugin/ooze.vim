if exists('g:loaded_ooze') || !has('nvim')
  finish
endif
let g:loaded_ooze = 1

if !exists('g:ooze_auto_advance')  | let g:ooze_auto_advance  = 1 | endif
if !exists('g:ooze_auto_scroll')   | let g:ooze_auto_scroll   = 1 | endif
if !exists('g:ooze_auto_exec')     | let g:ooze_auto_exec     = 1 | endif
if !exists('g:ooze_skip_comments') | let g:ooze_skip_comments = 1 | endif
if !exists('g:ooze_cr') | let g:ooze_cr = 1 | endif

function! CRooze() abort
  let l:ft = &filetype
  let l:line = getline('.')

  if l:ft ==# 'qf\|pager'
    return 0
  endif

  if l:line[0] ==# '#' && l:line[1] ==# '!'
    Info bang
    return 0
  endif

  if l:ft ==# 'vim' || l:ft ==# 'lua'
    " check if the line contains the word `function`
    " if it does, call ooze#fn that calls the function
    " see yankmkd for capturing and converting modnames
    execute (l:ft ==# 'lua' ? 'lua ' : '') . l:line
    Info (l:ft ==# 'lua' ? ' ' : ' ') . '[[' . l:line . ']]'
    return 1
  endif

  return ooze#send(l:line)
endfunction


" nnoremap <leader><CR> <Cmd>call ooze#init()<CR>
nnoremap <M-CR> <Cmd>call ooze#file()<CR>
" nnoremap <expr> <CR> CRooze() > 0 ? '' : "\<CR>"

augroup ooze
  autocmd!
  autocmd TermOpen * let g:ooze_channel = &channel
  autocmd TermOpen * let g:ooze_buffer = bufnr('%')
  " autocmd Filetype vim,lua nnoremap <buffer> <CR> <Cmd>call CRooze()<CR>
  " autocmd Filetype r,rmd nnoremap <buffer> <CR> <Cmd>call ooze#send(getline('.'))<CR>
  " autocmd Filetype vim,lua nnoremap <buffer> <CR> <Cmd>call ooze#send()<CR>
  " autocmd TermClose * unlet! g:ooze_channel
augroup END

" E841: Reserved name, cannot be used for user defined command
" However, Support for editing encrypted files has been removed in neovim
if has('nvim')
  command! -nargs=+ X call append('$', Append(<f-args>))
endif

command! -nargs=+ Append call append('$', Append(<f-args>))

function! Append(...) abort
  let args = a:000
  if args[0] == '!'
    let cmd = join(args[1:], ' ')
    return split(system(cmd), "\n")
  else
    return split(execute(join(args, ' ')), "\n")
  endif
endfunction

nnoremap <leader>A Append

function! XCmdline() abort
  let cmdline = getcmdline()
  if empty(cmdline) || getcmdtype()  != ':'
    return '<M-CR>'
  else
    call feedkeys("\<C-c>", 'n')
    call timer_start(0, {-> execute('call redir#execute("' . escape(cmdline, '"') . '")')})
  endif
endfunction

cnoremap <expr> <M-CR> XCmdline()

" -- local icon = (vim.g.ooze_channel ~= nil and vim.g.ooze_channel == vim.bo.channel) and ' ' or ' '
