function! textobjects#blanklines#() abort
  function! s:SelectInnerBlank() abort " {{{
    " Go up to first blank line
    let lnum = line('.')
    while lnum > 1 && getline(lnum - 1) =~ '^\s*$'
      let lnum -= 1
    endwhile
    " Mark start
    normal! m[
    " Go down to next blank line
    let end = line('.')
    while end < line('$') && getline(end + 1) =~ '^\s*$'
      let end += 1
    endwhile
    execute end . 'normal! m]'
    normal! `[V`]
  endfunction
  " }}}
  xnoremap i<Space> :<C-u>call <SID>SelectInnerBlank()<CR>
  onoremap i<Space> :<C-u>normal vi<Space><CR>

  function! s:SelectAroundBlank() abort " {{{
    " Like SelectInnerBlank, but include the surrounding blank lines
    let start = line('.')
    while start > 1 && getline(start - 1) =~ '^\s*$'
      let start -= 1
    endwhile
    if start > 1
      let start -= 1
    endif
    normal! m[
    let end = line('.')
    while end < line('$') && getline(end + 1) =~ '^\s*$'
      let end += 1
    endwhile
    if end < line('$')
      let end += 1
    endif
    execute end . 'normal! m]'
    normal! `[V`]
  endfunction
  " }}}
  xnoremap a<Space> :<C-u>call <SID>SelectAroundBlank()<CR>
  onoremap a<Space> :<C-u>normal va<Space><CR>
endfunction
" }}}
