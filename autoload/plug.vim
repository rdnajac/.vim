""
" Initialize the variable that will hold the list of plugins
" @setting g:plugins
let g:plugins = []

function! s:gh(repo) abort
  return  'https://github.com/' . a:repo
endfunction

" we only allow for a single argument for now
function! s:plug(bang, qargs) abort
  " this strips the surrounding quotes if any
  let l:repo = expand(eval(a:qargs))

  if a:bang
    call luaeval('vim.pack.add({_A})', s:gh(l:repo))
  else
    call add(g:plugins, s:gh(l:repo))
  endif
endfunction

" Public API
function! plug#begin() abort
  let g:plugins = []
  command! -nargs=1 -bar -bang Plug call s:plug(<bang>0, <q-args>)
endfunction

function! plug#end() abort
  delcommand Plug
  if !has('nvim')
    " from tpope/vim-sensible
    if !(exists('g:did_load_filetypes') && exists('g:did_load_ftplugin') && exists('g:did_indent_on'))
      filetype plugin indent on
    endif
    if has('syntax') && !exists('g:syntax_on')
      syntax enable
    endif
    return
  endif
  if !empty(g:plugins)
    lua vim.pack.add(vim.g.plugins, { confirm = false })
  endif
endfunction

function! s:handle_local_plugin(repo) abort
  if isdirectory(a:repo)
    let l:src = 'file://' . fnamemodify(a:repo, ':p')
    let l:name = fnamemodify(a:repo, ':t')

    if a:bang
      call luaeval('vim.pack.add({{ src = _A[1], name = _A[2] }})', [l:src, l:name])
    else
      " HACK: we must provide a name since the `file://` scheme
      " does not resolve names correctly.
      call luaeval('vim.pack.add({_A})', s:gh(l:repo))
    endif
  endif
endfunction
