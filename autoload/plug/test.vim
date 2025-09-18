function! s:parse(spec, ...) abort
  return 0
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

function! plug#test#() abort
  for case in s:cases
    if type(case) == type('')
      let spec = s:parse(case)
    elseif type(case) == type([])
      let repo = case[0]
      let opts = len(case) > 1 ? case[1] : {}
      let spec = s:parse(repo, opts)
    else
      let spec = []
    endif
    echo string(spec)
    echo '-------------------------'
  endfor
endfunction
