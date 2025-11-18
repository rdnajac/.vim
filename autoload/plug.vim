" silent! source ~/GitHub/junegunn/vim-plug/plug.vim

function! plug#begin(...)
  if a:0 > 0
    let g:plug_home = fnamemodify(expand(a:1), ':p')
  elseif !exists('g:plug_home')
    let g:plug_home = expand('~/.vim/plugged')
  endif
  let g:plugs = {}
  let g:plugs_order = []
  " let s:triggers = {}
  call s:define_commands()
  return 1
endfunction

function! s:define_commands()
  command! -nargs=+ -bar Plug call plug#(<args>)
  " command! -nargs=* -bar -bang -complete=customlist,s:names PlugInstall call s:install(<bang>0, [<f-args>])
  " command! -nargs=* -bar -bang -complete=customlist,s:names PlugUpdate  call s:update(<bang>0, [<f-args>])
  " command! -nargs=0 -bar -bang PlugClean call s:clean(<bang>0)
  " command! -nargs=0 -bar PlugUpgrade if s:upgrade() | execute 'source' s:esc(s:me) | endif
" command! -nargs=0 -bar PlugStatus  call s:status()
" command! -nargs=0 -bar PlugDiff    call s:diff()
" command! -nargs=? -bar -bang -complete=file PlugSnapshot call s:snapshot(<bang>0, <f-args>)
endfunction

function! s:trim(str) abort
  let ret = a:str
  while ret[-1] ==# '/'
    let ret = ret[:-2]
  endwhile
  return ret
endfunction

if has('nvim')
  function! plug#end()
    " lua vim.g.plugs = vim.tbl_map(function(plug) return plug.uri end, vim.tbl_values(vim.g.plugs or {}))
  endfunction

  " if !exists('g:loaded_plug')
  " silently fail if plug already defined (don't do `function!`)
  silent! function plug#(repo, ...)
  if a:0 > 1
    " return s:err('Invalid number of arguments (1..2)')
    Error 'Invalid number of arguments (1..2)'
    return
  endif

  try
    let l:repo = s:trim(a:repo)
    " let opts = a:0 == 1 ? s:parse_options(a:1) : s:base_spec
    " let name = get(opts, 'as', s:plug_fnamemodify(repo, ':t:s?\.git$??'))
    " let spec = extend(s:infer_properties(name, repo), opts)
    " if !has_key(g:plugs, name)
    " call add(g:plugs_order, name)
    " endif
    " let g:plugs[name] = spec
    " let s:loaded[name] = get(s:loaded, name, 0)
    let g:plugs[l:repo] = {'uri': git#url(l:repo)}
  catch
    Error repo . ' ' . v:exception
    return
  endtry
endfunction
" endif
endif
