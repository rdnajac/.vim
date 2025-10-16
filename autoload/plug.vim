" TODO: auto install
source ~/GitHub/junegunn/vim-plug/plug.vim

" override plug.vim
function! plug#end() abort
  delcommand Plug
endfunction

if exists('g:loaded_plug')
  finish
endif
let g:loaded_plug = v:true

function! plug#begin() abort
  if !exists('g:plug_home')
  " let g:plug_home = home
  endif
  " let g:plugs = {} " dictionary
  " let g:plugs_order = []
  " let s:triggers = {}
  let g:plugs = [] " list
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

function! plug#(repo, ...) abort
  if a:0 > 1
    return s:err('Invalid number of arguments (1..2)')
  endif
  try
    let repo = s:trim(a:repo)
    let opts = a:0 == 1 ? s:parse_options(a:1) : s:base_spec
    let name = get(opts, 'as', fnamemodify(repo, ':t:s?\.git$??'))
    let spec = extend(s:infer_properties(name, repo), opts)
    " if !has_key(g:plugs, name)
    " call add(g:plugs_order, name)
    " endif
    " let g:plugs[name] = spec
    " let s:loaded[name] = get(s:loaded, name, 0)
    " call add(g:plugs, a:repo)
    call add(g:plugs, 'http://github.com/'.a:repo.'.git')
  catch
    return s:err(repo . ' ' . v:exception)
  endtry
endfunction
