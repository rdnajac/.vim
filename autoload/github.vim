let s:repos = [
      \ 'dense-analysis/ale',
      \ 'lervag/vimtex',
      \ 'junegunn/vim-easy-align',
      \ 'tpope/vim-abolish',
      \ 'tpope/vim-apathy',
      \ 'tpope/vim-capslock',
      \ 'tpope/vim-characterize',
      \ 'tpope/vim-dispatch',
      \ 'tpope/vim-endwise',
      \ 'tpope/vim-eunuch',
      \ 'tpope/vim-git',
      \ 'tpope/vim-fugitive',
      \ 'tpope/vim-repeat',
      \ 'tpope/vim-obsession',
      \ 'tpope/vim-rsi',
      \ 'tpope/vim-scriptease',
      \ 'tpope/vim-sensible',
      \ 'tpope/vim-surround',
      \ 'tpope/vim-tbone',
      \ 'tpope/vim-unimpaired',
      \ 'alker0/chezmoi.vim',
      \ 'AndrewRadev/splitjoin.vim',
      \ 'AndrewRadev/dsf.vim',
      \ ]

function! github#repos() abort
  return s:repos
endfunction
