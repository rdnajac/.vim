function! plug#begin(...)
  if exists('g:loaded_jetpack')
    call jetpack#begin()
    call jetpack#add('tani/vim-jetpack')
    command! -nargs=+ -bar Plug call jetpack#add(<args>)
  elseif has('nvim')
    if a:0 > 0
      let g:plug_home = fnamemodify(expand(a:1), ':p')
    elseif !exists('g:plug_home')
      let g:plug_home = expand('~/.vim/plugged')
    endif
    let g:plugs = {}
    let g:plugs_order = []
    " let s:triggers = {}
    " call s:define_commands()
    command! -nargs=+ -bar Plug call plug#(<args>)
  endif
endfunction

function! s:trim(str) abort
  let ret = a:str
  while ret[-1] ==# '/'
    let ret = ret[:-2]
  endwhile
  return ret
endfunction

function plug#(repo, ...)
  if a:0 > 1
    Error 'Invalid number of arguments (1..2)'
  else
    try
      let l:repo = s:trim(a:repo)
      " let g:plugs[l:repo] = {'uri': git#url(l:repo)}
      call add(g:plugs_order, git#url(l:repo))
    catch
      Error repo . ' ' . v:exception
    endtry
  endif
endfunction

function! plug#end()
  delcommand Plug
  if exists('g:loaded_jetpack')
    call jetpack#end()
  elseif has('nvim')
    " lua vim.pack.add(vim.tbl_map(function(plug) return plug.uri end, vim.tbl_values(vim.g.plugs)))
    lua vim.pack.add(vim.g.plugs_order)
  endif
endfunction
