" Buffer pseudo-text objects
function! textobjects#buffer() abort
  " XXX: this is flaky
  xnoremap ig :<C-u>let z = @/\|1;/^./kz<CR>G??<CR>:let @/ = z<CR>V'z
  onoremap ig :<C-u>normal vig<CR>
  xnoremap ag GoggV
  onoremap ag :<C-u>normal vag<CR>
endfunction

""
" i_ i. i: i, i; i| i/ i\ i* i+ i- i#
" a_ a. a: a, a; a| a/ a\ a* a+ a- a#
" can take a count: 2i: 3a/
function! textobjects#simple() abort
  for char in [ '_', '.', ':', ',', ';', '<bar>', '/', '<bslash>', '*', '+', '-', '#' ]
    execute "xnoremap i" . char . " :<C-u>execute 'normal! ' . v:count1 . 'T" . char . "v' . (v:count1 + (v:count1 - 1)) . 't" . char . "'<CR>"
    execute "onoremap i" . char . " :normal vi" . char . "<CR>"
    execute "xnoremap a" . char . " :<C-u>execute 'normal! ' . v:count1 . 'F" . char . "v' . (v:count1 + (v:count1 - 1)) . 'f" . char . "'<CR>"
    execute "onoremap a" . char . " :normal va" . char . "<CR>"
  endfor
endfunction

function! textobjects#line() abort
  xnoremap il g_o^
  onoremap il :<C-u>normal vil<CR>
  xnoremap al $o0
  onoremap al :<C-u>normal val<CR>
endfunction

" integer and float
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
