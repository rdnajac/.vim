if exists('g:loaded_plug')
  finish
endif
let g:loaded_plug = 2 " `junegunn/vim-plug` sets this to 1
let g:plug_home = luaeval("vim.fs.joinpath(vim.fn.stdpath('data'), 'site', 'pack', 'core', 'opt')")

""
" register the `Plug` command
function! plug#begin() abort
  let g:plugins = []
  command! -nargs=1 -bar -bang Plug call s:plug(<bang>0, <q-args>)
endfunction

""
" we only allow for a single argument for now
function! s:plug(bang, qargs) abort
  " `expand` strips the surrounding quotes if any
  let l:repo = 'https://github.com/' . expand(eval(a:qargs)) . '.git'

  if a:bang " install immediately
    execute 'lua vim.pack.add({"' . l:repo . '"}, { confirm = false })'
  else " add to list for later installation
    call add(g:plugins, l:repo)
  endif
endfunction

function! plug#end() abort
  delcommand Plug
  if has('nvim')
    if !empty(g:plugins)
      lua vim.pack.add(vim.g.plugins, { confirm = false })
    endif
  else
    " from `tpope/vim-sensible`
    if !(exists('g:did_load_filetypes')
	  \ && exists('g:did_load_ftplugin')
	  \ && exists('g:did_indent_on'))
      filetype plugin indent on
    endif
    if has('syntax') && !exists('g:syntax_on')
      syntax enable
    endif
  endif
endfunction
