scriptencoding utf-8
let g:vim#notify#levels = #{ error: 'Error', warn: 'Warning', info: 'More' }

function! s:get_hl(level) abort
  return get(g:vim#notify#levels, a:level, 'Ok') .. 'Msg'
endfunction

function! vim#notify#(level, msg, ...) abort
  if has('nvim') && luaeval("_G.Snacks ~= nil")
    let opts = len(a:000) > 0 ? a:000[0] : {}
    let opts.title = '  vim#notify'
    " execute printf('lua Snacks.notify.%s([[%s]])', a:level, a:msg)
    " call luaeval('Snacks.notify[_A.level](_A.msg)', {'level': a:level, 'msg': a:msg})
    call luaeval('Snacks.notifier.notify(unpack(_A))', [a:msg, a:level, opts])
  else
    execute 'echohl' s:get_hl(a:level)
    echomsg a:msg
    echohl None
  endif
endfunction

for level in keys(g:vim#notify#levels)
  execute join([$'fun! vim#notify#{level}(msg) abort', $'call vim#notify#("{level}", a:msg)', 'endfun'], "\<NL>")
endfor
" " :Error/:Warn/:Info wrappers around vim#notify#
" " the argument is evaluated, so both `:Warn 'msg'` and `:Warn v:termrequest` work
" for s:level in ['error', 'warn', 'info']
"   execute printf('command! -nargs=1 -complete=expression %s call vim#notify#%s(eval(<q-args>))',
"  \ toupper(strpart(s:level, 0, 1))..strpart(s:level, 1), s:level)
" endfor
" unlet s:level
