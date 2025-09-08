if exists('g:loaded_plug')
  finish
endif
let g:loaded_plug = 2 " `junegunn/vim-plug` sets this to 1

""
" Initialize plugin system
function! plug#begin() abort
  let g:plug#list = []
  command! -nargs=? -bar Plug call plug#(<args>)
  " command! -nargs=? -bang -bar Plug call plug#(<args>, <bang>0)
  " execute 'lua require("plug")("' . a:repo . '")'
endfunction

function! plug#(repo, ...) abort
  " if a:bang
  " execute 'lua require("plug")("' . a:repo . '")'
  " else
  call add(g:plug#list, a:repo)
  " endif
endfunction

function! plug#parse(spec, ...) abort
  " FIXME:
endfunction

" examples from the `vim-plug` docs
let s:cases = [
      \ 'junegunn/seoul256.vim',
      \ 'https://github.com/junegunn/vim-easy-align.git',
      \ 'fatih/vim-go', { 'tag': '*' },
      \ 'neoclide/coc.nvim', { 'branch': 'release' },
      \ 'junegunn/fzf', { 'dir': '~/.fzf' },
      \ 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' },
      \ 'junegunn/fzf', { 'do': { -> fzf#install() } },
      \ 'nsf/gocode', { 'rtp': 'vim' },
      \ 'preservim/nerdtree', { 'on': 'NERDTreeToggle' },
      \ 'tpope/vim-fireplace', { 'for': 'clojure' },
      \ '~/my-prototype-plugin',
      \ ]

function! plug#test() abort
  for case in s:cases
    if type(case) == type('')
      let spec = plug#parse(case)
    elseif type(case) == type([])
      let repo = case[0]
      let opts = len(case) > 1 ? case[1] : {}
      let spec = plug#parse(repo, opts)
    else
      let spec = []
    endif
    echo string(spec)
    echo '-------------------------'
  endfor
endfunction

""
" Finalize plugin system:
" First the Plug command is deleted to avoid conflicts. Then, if running in
" Neovim and there are plugins to install, they are added. Otherwise, syntax
" and filetype detection, plugins, and indenting are enabled
" using the guards copied from `tpope/vim-sensible`
" @public
function! plug#end() abort
  " delcommand Plug
  if has('nvim')
    lua require('nvim.plug').end_()
    " lua vim.pack.add(vim.g['plug#list'], { confirm = false })
  else
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
