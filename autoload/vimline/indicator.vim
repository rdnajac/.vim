scriptencoding utf-8

function! vimline#indicator#bom() abort
  return &fileencoding . (&bomb ? ' [BOM]' : '')
endfunction

" ALE statusline component
" https://github.com/dense-analysis/ale?tab=readme-ov-file#custom-statusline
" set statusline=%{LinterStatus()w  w}
function! vimline#indicator#ale_diagnostics() abort
  let counts = ale#statusline#Count(bufnr(''))
  let all_errors = counts.error + counts.style_error
  let non_errors = counts.total - all_errors
  return counts.total == 0 ? 'OK' : printf(' %dW %dE', non_errors, all_errors)
endfunction

function! vimline#indicator#searchcount() abort
  let res = searchcount({ 'maxcount': 999, 'timeout': 500 })

  if v:hlsearch == 0 || empty(res) || !has_key(res, 'current')
    return ''
  endif

  return printf('[%d/%d]', res.current, min([res.total, res.maxcount]))
endfunction

" Or if you want to show the count only when
" let &statusline .='%{v:hlsearch ? LastSearchCount() : ""}'
