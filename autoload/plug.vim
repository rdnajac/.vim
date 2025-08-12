let g:plugins = []

function! s:gh(repo) abort
  return  'https://github.com/' . a:repo
endfunction

function! s:plug(bang, qargs) abort
  " we only allow for a single argument for now
  " this strips the surrounding quotes if any
  let l:repo = expand(eval(a:qargs))

  if isdirectory(repo)
    let l:src = 'file://' . fnamemodify(repo, ':p')
    let l:name = fnamemodify(repo, ':t')

    if a:bang
      " HACK: we must provide a name since the `file://` scheme 
      " does not resolve names correctly.
      call luaeval('vim.pack.add({{ src = _A[1], name = _A[2] }})', [l:src, l:name])
    else
      echom 'skipping local plugin ' . l:name
      " TODO: support adding local plugin to plugins list for load=false
      " call add(g:plugins, repo)
    endif
  else
    if a:bang
      call luaeval('vim.pack.add({_A})', s:gh(l:repo))
    else
      call add(g:plugins, s:gh(l:repo))
    endif
  endif
endfunction

" Public API
function! plug#begin() abort
  let g:plugins = []
  command! -nargs=1 -bar -bang Plug call s:plug(<bang>0, <q-args>)
endfunction

function! plug#end() abort
  delcommand Plug
  if !empty(g:plugins)
    call luaeval('vim.pack.add(_A, {load = false})', g:plugins)
  endif
endfunction
