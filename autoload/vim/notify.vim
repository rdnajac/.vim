" autoload/vim/notify.vim
function s:notify(level, msg) abort
  if has('nvim') && luaeval("_G.Snacks ~= nil or package.loaded['Snacks'] ~= nil")
    execute printf('lua Snacks.notify.%s([[%s]])', a:level, a:msg)
  else
    if a:level ==# 'error'
      echohl ErrorMsg
    elseif a:level ==# 'warn'
      echohl WarningMsg
    elseif a:level ==# 'info'
      echohl MoreMsg
    endif
    echom a:msg
    echohl None
  endif
endfunction

function vim#notify#(msg) abort
  call s:notify('', a:msg)
endfunction

function vim#notify#warn(msg) abort
  call s:notify('warn', a:msg)
endfunction

function vim#notify#info(msg) abort
  call s:notify('info', a:msg)
endfunction

function vim#notify#error(msg) abort
  call s:notify('error', a:msg)
endfunction

" function! vim#notify#setup() abort
"   for level in ['', 'error', 'info', 'warn']
" execute printf('function vim#notify#(msg) abort \<Bar> call s:notify("notify", a:msg) \<Bar> endfunction')
"   endfor
" endfunction
"
" call vim#notify#setup()
