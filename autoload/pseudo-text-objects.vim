" 24 simple pseudo-text objects
" -----------------------------
" i_ i. i: i, i; i| i/ i\ i* i+ i- i#
" a_ a. a: a, a; a| a/ a\ a* a+ a- a#
" can take a count: 2i: 3a/
for char in [ '_', '.', ':', ',', ';', '<bar>', '/', '<bslash>', '*', '+', '-', '#' ]
  execute "xnoremap i" . char . " :<C-u>execute 'normal! ' . v:count1 . 'T" . char . "v' . (v:count1 + (v:count1 - 1)) . 't" . char . "'<CR>"
  execute "onoremap i" . char . " :normal vi" . char . "<CR>"
  execute "xnoremap a" . char . " :<C-u>execute 'normal! ' . v:count1 . 'F" . char . "v' . (v:count1 + (v:count1 - 1)) . 'f" . char . "'<CR>"
  execute "onoremap a" . char . " :normal va" . char . "<CR>"
endfor

" Line pseudo-text objects
" ------------------------
" il al
xnoremap il g_o^
onoremap il :<C-u>normal vil<CR>
xnoremap al $o0
onoremap al :<C-u>normal val<CR>

" Number pseudo-text object (integer and float)
" ---------------------------------------------
" in
function! VisualNumber()
  call search('\d\([^0-9\.]\|$\)', 'cW')
  normal v
  call search('\(^\|[^0-9\.]\d\)', 'becW')
endfunction
xnoremap in :<C-u>call VisualNumber()<CR>
onoremap in :<C-u>normal vin<CR>

" Square brackets pseudo-text objects
" -----------------------------------
" ir ar
" can take a count: 2ar 3ir
xnoremap ir i[
onoremap ir :<C-u>execute 'normal v' . v:count1 . 'i['<CR>
xnoremap ar a[
onoremap ar :<C-u>execute 'normal v' . v:count1 . 'a['<CR>

" Block comment pseudo-text objects
" ---------------------------------
" i? a?
xnoremap a? [*o]*
onoremap a? :<C-u>normal va?V<CR>
xnoremap i? [*jo]*k
onoremap i? :<C-u>normal vi?V<CR>

" C comment pseudo-text object
" ----------------------------
" i? a?
xnoremap i? [*jo]*k
onoremap i? :<C-u>normal vi?V<CR>
xnoremap a? [*o]*
onoremap a? :<C-u>normal va?V<CR>

" Last khange pseudo-text objects ;-)
" -----------------------------------
" ik ak
xnoremap ik `]o`[
onoremap ik :<C-u>normal vik<CR>
onoremap ak :<C-u>normal vikV<CR>

" XML/HTML/etc. attribute pseudo-text object
" ------------------------------------------
" ix ax
xnoremap ix a"oB
onoremap ix :<C-u>normal vix<CR>
xnoremap ax a"oBh
onoremap ax :<C-u>normal vax<CR>

" Fenced code block in Markdown
" -----------------------------
" if
" See https://stackoverflow.com/questions/75587279/quick-way-to-select-inside-a-fenced-code-block-in-markdown-using-vim
" To be put in after/ftplugin/markdown.vim
function! s:SelectInnerCodeBlock()
  function! IsFence()
    return getline('.') =~ '^```'
  endfunction

  function! IsOpeningFence()
    return IsFence() && getline(line('.'),'$')->filter({ _, val -> val =~ '^```'})->len() % 2 == 0
  endfunction

  function! IsBetweenFences()
    return synID(line("."), col("."), 0)->synIDattr('name') =~? 'markdownCodeBlock'
  endfunction

  function! IsClosingFence()
    return IsFence() && !IsOpeningFence()
  endfunction

  if IsOpeningFence() || IsBetweenFences()
    call search('^```', 'W')
    normal -
    call search('^```', 'Wbs')
    normal +
    normal V''
  elseif IsClosingFence()
    call search('^```', 'Wbs')
    normal +
    normal V''k
  else
    return
  endif
endfunction
xnoremap <buffer> <silent> if :<C-u>call <SID>SelectInnerCodeBlock()<CR>
onoremap <buffer> <silent> if :<C-u>call <SID>SelectInnerCodeBlock()<CR>

" ------------------------------------------------------------------------------
" Select 'inside blank lines' (i<Space>)
xnoremap i<Space> :<C-u>call <SID>SelectInnerBlank()<CR>
onoremap i<Space> :<C-u>normal vi<Space><CR>

" Select 'around blank lines' (a<Space>)
xnoremap a<Space> :<C-u>call <SID>SelectAroundBlank()<CR>
onoremap a<Space> :<C-u>normal va<Space><CR>

" Core selection functions:
function! s:SelectInnerBlank() abort
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

function! s:SelectAroundBlank() abort
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
