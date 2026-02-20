""
" @public
" Get the git repository root directory.
" Uses Snacks.nvim if available, falls back to Fugitive, then manual search.
" [buffer] can be a buffer number or buffer name. Defaults to current buffer.
function! git#root(...) abort
  if has('nvim') && luaeval("package.loaded['snacks'] ~= nil")
    try
      return a:0 ? luaeval('require("snacks.git").get_root(_A)', a:1) : v:lua.Snacks.git.get_root()
    catch
    endtry
  endif

  if exists('*FugitiveGitDir')
    let l:gitdir = FugitiveGitDir(a:000)
  else
    let l:buf = a:0 ? a:1 : bufnr('%')
    let l:bufnr = type(l:buf) == v:t_string ? bufnr(l:buf) : l:buf
    let l:gitdir = finddir('.git', fnamemodify(bufname(l:bufnr), ':p') . ';')
  endif
  return empty(l:gitdir) ? '' : fnamemodify(l:gitdir, ':p:h:h')
endfunction

""
" @public
" Generate a GitHub repository URL from {user_repo}.
" {user_repo} should be in the format "username/repository".
" Returns the full git URL for cloning.
function! git#url(user_repo) abort
  return 'https://git::@github.com/' .. a:user_repo .. '.git'
endfunction

function! git#repo(user_repo) abort
  return 'https://github.com/' .. a:user_repo .. '.git'
endfunction
