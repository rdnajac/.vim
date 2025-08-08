function! s:execute_line() abort
  let l:line = getline('.')
  if &filetype ==# 'lua'
    let l:line = 'lua ' . l:line
  elseif &filetype !=# 'vim'
    echom l:line
    return
  endif
  execute l:line
  echom l:line
endfunction

function! s:source_file() abort
  execute 'source %'
  echom 'sourced `' . expand('%') . '`!'
endfunction

augroup MapCR
  autocmd!
  autocmd FileType vim,lua nnoremap <buffer> <silent> <CR> <Cmd>call <SID>execute_line()<CR>
  autocmd FileType vim,lua nnoremap <buffer> <silent> <M-CR> <Cmd>call <SID>source_file()<CR>
  autocmd FileType     lua nnoremap <buffer> <silent> <leader><CR> <Cmd>lua Snacks.debug.run()<CR>
  autocmd FileType     lua vnoremap <buffer> <silent> <leader><CR> :lua Snacks.debug.run()<CR>
augroup END

finish
" eunuch compatibility for <CR> mapping

function! EunuchNewLine(...) abort
  if a:0 && type(a:1) == type('')
    return a:1 . (a:1 =~# "\r" && empty(&buftype) ? "\<C-R>=EunuchNewLine()\r" : "")
  endif
  if !empty(&buftype) || getline(1) !~# '^#!$\|' . s:shebang_pat || line('.') != 2 || getline(2) !~# '^#\=$'
    return ""
  endif
  let b:eunuch_chmod_shebang = 1
  let inject = ''
  let detect = 0
  let ret = empty(getline(2)) ? "" : "\<C-U>"
  if getline(1) ==# '#!'
    let inject = s:FileTypeInterpreter()
    let detect = !empty(inject) && empty(&filetype)
  else
    filetype detect
    if getline(1) =~# '^#![^ /].\{-\}[ \''"#]'
      let inject = '/usr/bin/env -S '
    elseif getline(1) =~# '^#![^ /]'
      let inject = '/usr/bin/env '
    endif
  endif
  if len(inject)
    let ret .= "\<Up>\<Right>\<Right>" . inject . "\<Home>\<Down>"
  endif
  if detect
    let ret .= "\<C-\>\<C-O>:filetype detect\r"
  endif
  return ret
endfunction

function! s:MapCR() abort
  imap <silent><script> <SID>EunuchNewLine <C-R>=EunuchNewLine()<CR>
  let map = maparg('<CR>', 'i', 0, 1)
  let rhs = substitute(get(map, 'rhs', ''), '\c<sid>', '<SNR>' . get(map, 'sid') . '_', 'g')
  if get(g:, 'eunuch_no_maps') || rhs =~# 'Eunuch' || get(map, 'desc') =~# 'Eunuch' || get(map, 'buffer')
    return
  endif
  let imap = get(map, 'script', rhs !~? '<plug>') || get(map, 'noremap') ? 'imap <script>' : 'imap'
  if get(map, 'expr') && type(get(map, 'callback')) == type(function('tr'))
    lua local m = vim.fn.maparg('<CR>', 'i', 0, 1); vim.api.nvim_set_keymap('i', '<CR>', m.rhs or '', { expr = true, silent = true, callback = function() return vim.fn.EunuchNewLine(vim.api.nvim_replace_termcodes(m.callback(), true, true, m.replace_keycodes)) end, desc = "EunuchNewLine() wrapped around " .. (m.desc or "Lua function") })
  elseif get(map, 'expr') && !empty(rhs)
    exe imap '<silent><expr> <CR> EunuchNewLine(' . rhs . ')'
  elseif rhs =~? '^\%(<c-\]>\)\=<cr>' || rhs =~# '<[Pp]lug>\w\+CR'
    exe imap '<silent> <CR>' rhs . '<SID>EunuchNewLine'
  elseif empty(rhs)
    imap <script><silent><expr> <CR> EunuchNewLine("<Bslash>035<Bslash>r")
  endif
endfunction
call s:MapCR()

" TODO: ooze send
