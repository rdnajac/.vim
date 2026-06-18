" inner/outer function
" xnoremap if :<C-u>normal! Bvf(<CR>
" onoremap if :<C-u>normal vif<CR>
" xnoremap af :<C-u>normal! Bvf)<CR>
" onoremap af :<C-u>normal vaf<CR>

" inner argument (just the value)
" xnoremap ia <Cmd>normal! F,wvf,h<CR>
" onoremap ia <Cmd>normal! via<CR>

" outer argument (includes the comma and space)
" xnoremap aa <Cmd>normal! F,vf,<CR>
" onoremap aa <Cmd>normal! vaa<CR>

" set up text objects mappings for codeblock
function! textobjects#codeblock_map() abort
  xnoremap <buffer> ac :<C-u>call textobjects#codeblock#outer()<CR>
  onoremap <buffer> ac :<C-u>normal vac<CR>
  xnoremap <buffer> ic :<C-u>call textobjects#codeblock#inner()<CR>
  onoremap <buffer> ic :<C-u>normal vic<CR>
endfunction

function! textobjects#number() abort
  function! VisualNumber()
    call search('\d\([^0-9\.]\|$\)', 'cW')
    normal v
    call search('\(^\|[^0-9\.]\d\)', 'becW')
  endfunction
  xnoremap in :<C-u>call VisualNumber()<CR>
  onoremap in :<C-u>normal vin<CR>
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
