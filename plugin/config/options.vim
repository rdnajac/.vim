set autochdir                   " change directory to the file being edited
set completeopt+=preview	" show preview window
set completeopt=menuone,noselect " show menu even if there's only one match
set cursorline                  " highlight the current line
set foldopen+=insert,jump
set ignorecase smartcase        " ignore case when searching, unless there's a capital letter
set iskeyword+=_                " is used for word motions, completion, etc.
set linebreak breakindent       " break at word boundaries and indent
set nowrap                      " don't wrap lines by default
set number relativenumber       " show (relative) line numbers
set numberwidth=3               " line number column padding
set pumheight=10                " limit the number of items in a popup menu
set report=0                    " display how many replacements were made
set scrolloff=5                 " default 0, set to 5 in defaults.vim
set shiftround			" round indent to multiple of shiftwidth
set showmatch                   " highlight matching brackets
set splitbelow splitright       " where to open new splits by default
set timeoutlen=420		" ms for a mapped sequence to complete
set updatetime=100              " used for CursorHold autocommands
set whichwrap+=<,>,[,],h,l      " wrap around newlines with these keys

if has('nvim')
  echom '>^.^<'
  set pumblend=10
  set signcolumn=yes
  let g:tmux_navigator_disable_netrw_workaround = 1
else
  silent! color scheme            " my colorscheme (in ~/.vim/colors/)
endif
