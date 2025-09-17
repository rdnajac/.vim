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
  Info 'Selecting code block'
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
" FIXME: 
xnoremap <buffer> <silent> ij :<C-u>call <SID>SelectInnerCodeBlock()<CR>
onoremap <buffer> <silent> ij :<C-u>call <SID>SelectInnerCodeBlock()<CR>
