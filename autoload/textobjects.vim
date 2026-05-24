" inner/outer function
" xnoremap if :<C-u>normal! Bvf(<CR>
" onoremap if :<C-u>normal vif<CR>
" xnoremap af :<C-u>normal! Bvf)<CR>
" onoremap af :<C-u>normal vaf<CR>

function! textobjects#number() abort
  function! VisualNumber()
    call search('\d\([^0-9\.]\|$\)', 'cW')
    normal v
    call search('\(^\|[^0-9\.]\d\)', 'becW')
  endfunction
  xnoremap in :<C-u>call VisualNumber()<CR>
  onoremap in :<C-u>normal vin<CR>
endfunction

function! textobjects#brackets() abort
  xnoremap ir i[
  onoremap ir :<C-u>execute 'normal v' . v:count1 . 'i['<CR>
  xnoremap ar a[
  onoremap ar :<C-u>execute 'normal v' . v:count1 . 'a['<CR>
endfunction

function! textobjects#blockcomment() abort
  xnoremap a? [*o]*
  onoremap a? :<C-u>normal va?V<CR>
  xnoremap i? [*jo]*k
  onoremap i? :<C-u>normal vi?V<CR>
endfunction

function! textobjects#ccoment() abort
  xnoremap i? [*jo]*k
  onoremap i? :<C-u>normal vi?V<CR>
  xnoremap a? [*o]*
  onoremap a? :<C-u>normal va?V<CR>
endfunction

function! textobjects#lastchange() abort
  xnoremap ik `]o`[
  onoremap ik :<C-u>normal vik<CR>
  onoremap ak :<C-u>normal vikV<CR>
endfunction

" XML/HTML/etc.
function! textobjects#attribute() abort
  xnoremap ix a"oB
  onoremap ix :<C-u>normal vix<CR>
  xnoremap ax a"oBh
  onoremap ax :<C-u>normal vax<CR>
endfunction

function! textobjects#blanklines() abort
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

" vim: fdm=marker
