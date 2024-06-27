let g:mapleader = ' '
let g:maplocalleader = "\\"

nnoremap ?         :call GetInfo()<cr>
nnoremap <leader>r :source $MYVIMRC<cr>
nnoremap <leader>w :w<cr>
nnoremap <leader>Q :qa!<cr>
nnoremap <C-q>     :wqall<CR>

" edit vim files
nnoremap <leader>vv :vsplit $MYVIMRC<cr>
" function to open the snippetsfile for the current filetype in split

function! EditSnips() abort
  let ft = &filetype
  let snippetsfile = expand('~/.vim/UltiSnips/'.ft.'.snippets')
  if filereadable(snippetsfile)
    execute 'vsplit' snippetsfile
  else
    echo 'No snippets file found for '.ft
  endif
endfunction

nnoremap <leader>vs :call EditSnips()<cr>
nnoremap <leader>ep <esc>:vsplit ~/.vim/after/plugin/
nnoremap <leader>ea <esc>:vsplit ~/.vim/autoload/
nnoremap <leader>es <esc>:vsplit ~/.vim/UltiSnips/

" toggle settings
nnoremap <leader>sl :set list!<CR>
nnoremap <leader>sn :set number!<CR>
nnoremap <leader>sr :set relativenumber!<CR>
nnoremap <leader>sw :set wrap!<CR>
nnoremap <leader>ss :set spell!<CR>
nnoremap <leader>scl :set cursorline!<CR>
" nnoremap <leader>scc :set cursorcolumn!<CR>
nnoremap <leader>sh :set hlsearch!<CR>

" indent/dedent visual block
nnoremap > V`]>
nnoremap < V`]<

" quick escape
inoremap jk <esc>
vnoremap jk <esc>
inoremap kj <esc>
vnoremap jk <esc>

" Move the current line up/down
nnoremap <silent> <C-k> :move .-2<CR>=
nnoremap <silent> <C-j> :move .+1<CR>==
xnoremap <silent> <C-k> :move '<-2<CR>gv=gv
xnoremap <silent> <C-j> :move '>+1<CR>gv=gv

" buffers and windows
nnoremap <tab>   :bnext<cr>
nnoremap <s-tab> :bprevious<cr>

" force `:X` to behave like `:x`
cnoreabbrev <expr> X getcmdtype() == ':' && getcmdline() == 'X' ? 'x' : 'X'

" better completion
inoremap <silent> <localleader>o <C-x><C-o>
inoremap <silent> ,f <C-x><C-f>
inoremap <silent> ,i <C-x><C-i>
inoremap <silent> ,l <C-x><C-l>
inoremap <silent> ,n <C-x><C-n>
inoremap <silent> ,t <C-x><C-]>
inoremap <silent> ,u <C-x><C-u>


" https://web.archive.org/web/20230418005002/https://www.vi-improved.org/recommendations/
" nnoremap <leader>a :argadd <c-r>=fnameescape(expand('%:p:h'))<cr>/*<C-d>
" nnoremap <leader>b :b <C-d>
" nnoremap <leader>e :e **/
" nnoremap <leader>g :grep<space>
" nnoremap <leader>i :Ilist<space>
" nnoremap <leader>j :tjump /
" nnoremap <leader>m :make<cr>
" nnoremap <leader>s :call StripTrailingWhitespace()<cr>
" nnoremap <leader>q :b#<cr>
" nnoremap <leader>t :TTags<space>*<space>*<space>.<cr>

" L-a :: lets me add files with wildcards, like **/*.md for all markdown files, very useful.
" L-b :: lands me on the buffer prompt and displays all buffers so I can just type a partial to switch to that buffer
" L-e :: similar to buffers but for opening a single file
" L-g :: it just drops me to the grep line
" L-i :: uses the Ilist function from qlist -- makes :ilist go into a quickfix window, awesome
" L-j :: lands me on a taglist jump command line, for performance reasons I don't do a -- but you totally could
" L-m :: runs make, simple but very useful once you start setting up proper make configurations for everything
" L-s :: strips whitespace using my little function (below)
" L-q :: switches to the last buffer I was editing, I use this all the darn time to (q)uickswitch
" L-t :: runs :TTags but on the current file, lands me on a prompt to filter the tags
