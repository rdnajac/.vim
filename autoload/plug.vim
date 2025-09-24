if exists('g:loaded_plug')
  finish
endif
if !has('nvim')
  " if we're on vim, there is still time to curl the plug.vim file and source
  " it; need to ensure plug#begin behaves correctly since we probably won't
  " get another chance to call it unless we do something funky with autocmds?
  finish " for now...
endif
let g:loaded_plug = 2 " `junegunn/vim-plug` sets this to 1

let s:plugs = []

function! plug#begin() abort
  let s:plugs = [] " reset the list of plugs
  command! -nargs=+ -bar Plug call plug#(<args>)
endfunction

function! plug#(repo, ...) abort
  call add(s:plugs, a:repo)
  " call add(s:plugs, 'http://github.com/' . a:repo . '.git')
endfunction

function! plug#end() abort
  delcommand Plug
  if !exists('g:pluglist')
    let g:pluglist = deepcopy(s:plugs)
  else
    Warn "plug# reloaded!"
    " call plug#reload#()
  endif
  " lua vim.pack.add(vim.g.pluglist)
endfunction
