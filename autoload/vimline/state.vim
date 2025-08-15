scriptencoding=utf-8
function! vimline#state#recording() abort
  let rec = reg_recording()
  let reg = empty(rec) ? get(g:, 'vimline_last_reg', 'q') : rec
  let icon = empty(rec) ? '@' : '󰑋'
  let ret = '[' . icon . reg . '] '
  " if empty(rec)
  "   let macro = escape(keytrans(getreg(reg)), '%\|')
  "   return ret . macro . ' '
  " endif
  return ret
endfunction

" ALE statusline component
" https://github.com/dense-analysis/ale?tab=readme-ov-file#custom-statusline
" set statusline=%{LinterStatus()w  w}
function! vimline#state#diagnostics() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? 'OK' : printf(' %dW %dE', l:non_errors, l:all_errors)
endfunction
