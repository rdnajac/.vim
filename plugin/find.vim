" https://web.archive.org/web/20230418005002/https://www.vi-improved.org/recommendations/
finish
nnoremap <leader>a :argadd <c-r>=fnameescape(expand('%:p:h'))<cr>/*<C-d>
nnoremap <leader>b :b <C-d>
nnoremap <leader>e :e **/
nnoremap <leader>g :grep<space>
nnoremap <leader>i :Ilist<space>
nnoremap <leader>j :tjump /
nnoremap <leader>m :make<cr>
nnoremap <leader>s :call StripTrailingWhitespace()<cr>
nnoremap <leader>q :b#<cr>
nnoremap <leader>t :TTags<space>*<space>*<space>.<cr>

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
