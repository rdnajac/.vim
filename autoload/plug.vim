if exists('g:loaded_jetpack')
  " Info 'exists'
  function! plug#begin(...)
    call jetpack#begin()
    call jetpack#add("tani/vim-jetpack")
  endfunction
  command! -nargs=+ -bar Plug call jetpack#add(<args>)
  function! plug#end()
    if exists('g:loaded_jetpack')
      call jetpack#end()
      call jetpack#sync()
    endif
  endfunction
elseif has('nvim')

  function! plug#begin(...)
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
    return 1
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
      return
    endif

    try
      let l:repo = s:trim(a:repo)
      let g:plugs[l:repo] = {'uri': git#url(l:repo)}
    catch
      Error repo . ' ' . v:exception
      return
    endtry
  endfunction

  function! plug#end()
    " lua dd(vim.g.plugs)
    " lua vim.g.plugs = vim.tbl_map(function(plug) return plug.uri end, vim.tbl_values(vim.g.plugs or {}))
  endfunction
endif
