function! s:joinpath(list) abort
  return join(a:list, &shellslash ? '/' : '\\')
endfunction

" vim plugin using vim-fugitive to manage plugins as git submodules
let s:gitroot = git#root()
let s:vimfect_opt = s:joinpath([s:gitroot, 'pack', 'vimfect', 'opt'])
let s:vimfect_start = s:joinpath([s:gitroot, 'pack', 'vimfect', 'start'])

function s:add_submodule(user_repo)
  execute printf('Git submodule add %s %s', git#repo(a:user_repo), s:joinpath([s:optdir, fnamemodify(a:user_repo, ':t')]))
endfunction

" call s:add_submodule('rdnajac/vim-lol')
