scriptencoding utf-8

function! vimline#indicator#bom() abort
  return &fileencoding . (&bomb ? ' [BOM]' : '')
endfunction

" ALE statusline component
" https://github.com/dense-analysis/ale?tab=readme-ov-file#custom-statusline
" set statusline=%{LinterStatus()w  w}
function! vimline#indicator#ale_diagnostics() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? 'OK' : printf(' %dW %dE', l:non_errors, l:all_errors)
endfunction

function! vimline#indicator#searchcount() abort
  let l:res = searchcount({ 'maxcount': 999, 'timeout': 500 })

  if v:hlsearch == 0 || empty(l:res) || !has_key(l:res, 'current')
    return ''
  endif

  return printf('[%d/%d]', l:res.current, min([l:res.total, l:res.maxcount]))
endfunction

" Or if you want to show the count only when
" let &statusline .='%{v:hlsearch ? LastSearchCount() : ""}'
