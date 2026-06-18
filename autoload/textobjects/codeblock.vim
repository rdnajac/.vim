let s:fence = '^```'
function! s:is_fence() abort
  let lnum = line('.')
  let line = getline(lnum)
  return line !~? s:fence ? 0 :
	\ len(getline(lnum, '$')->filter({_, l -> l =~ '^```'})) % 2 == 0 ? 1 : -1
endfunction

" TODO: embed the lua if the eval doesnt work
" M.inside_code_fences = function()
"   local ok, node = pcall(
"   return (ok and node) and vim.treesitter.get_node):type():match('code') ~= nil or false
" end

function! s:is_between_fences() abort
  if empty(&syntax) && has('nvim')

    return luaeval('(function() local ok,n = pcall(vim.treesitter.get_node); return ok and n ~= nil and n:type():match("code") ~= nil end)()')
  endif
  return synID(line('.'), col('.'), 0)->synIDattr('name') =~? 'markdownCodeBlock'
endfunction

" search: `W`: don't wrap, `b`: backwards, `s`: set `'` mark
function! textobjects#codeblock#(inner) abort " {{{
  let fence_kind = s:is_fence()
  if fence_kind < 0                    " cursor on closing fence
    call search(s:fence, 'Wbs')        " find opening fence
    if a:inner | exe 'norm! +' | endif " move down if inner
    normal! V''
    if a:inner | exe 'norm! -' | endif " move up if inner
  elseif fence_kind > 0 || s:is_between_fences()
    call search(s:fence, 'W')          " find closing fence
    if a:inner | exe 'norm! -' | endif " move up if inner
    call search(s:fence, 'Wbs')        " find opening fence
    if a:inner | exe 'norm! +' | endif " move down if inner
    normal! V''
  endif
endfunction

function! textobjects#codeblock#outer() abort
  call textobjects#codeblock#(0)
endfunction

function! textobjects#codeblock#inner() abort
  call textobjects#codeblock#(1)
endfunction
