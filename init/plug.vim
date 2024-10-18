" Manage plugins with vim-plug

" https://cs4118.github.io/dev-guides/vim-workflow.html
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    exec 'autocmd VimEnter * PlugInstall --sync | source $MYVIMRC'
endif

call plug#begin('~/.vim/.plugged')
Plug 'tpope/vim-apathy'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-scriptease'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-vinegar'
Plug 'godlygeek/tabular'
Plug 'wellle/targets.vim'
Plug 'lervag/vimtex'
Plug 'flwyd/vim-conjoin'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npx --yes yarn install' }
Plug 'machakann/vim-highlightedyank'
Plug 'github/copilot.vim'
Plug 'dense-analysis/ale'
Plug 'ycm-core/YouCompleteMe'
Plug 'ervandew/supertab'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
call plug#end()
