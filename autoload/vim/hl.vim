""
" Set and link highlight group colors

function! vim#hl#set(group, fg, bg, ...) abort
  let l:attr = (a:0 > 0 && !empty(a:1)) ? a:1 : 'NONE'
  " Use highlight! to override existing settings
  execute printf(
	\ 'highlight! %s guifg=%s guibg=%s gui=%s cterm=%s',
	\ a:group, a:fg, a:bg, l:attr, l:attr
	\)
endfunction

""
" Link multiple highlight groups to a base group
" Accepts either a list or multiple arguments
function! vim#hl#link(base, ...) abort
  let l:groups = a:0 == 1 && type(a:1) == v:t_list ? a:1 : a:000
  for l:group in l:groups
    if !empty(l:group)
      " TODO: do I need to clear the group first?
      execute 'highlight! clear' l:group
      execute 'highlight! link' l:group a:base
    endif
  endfor
endfunction
