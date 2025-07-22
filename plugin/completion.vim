" see `:h |cmdline-completion|.`
set completeopt=menu,preview,longest

" TODO: this check if this works on the default version in GitHub Codespaces
" if has('nvim') || has('patch-9.1.1337')
" set completeopt+=preinsert
" endif

" First press: longest common substring
" Second press: cycle through full matches
" set wildmode=longest,full

" Same as above, but cycle through the first patch ('preinsert'?)
set wildmode=longest:full,full

" First press: longest common substring
" Second press: list all matches >vim
" set wildmode=longest,list

" First press: show 'wildmenu' without completing or selecting
" Second press: cycle full matches >vim
" set wildmode=noselect:full

" Same as above, but buffer matches are sorted by time last used
" More info here: |cmdline-completion|.
" set wildmode=noselect:lastused,full

" Up and Down arrow keys to navigate completion menu
cnoremap <expr> <Down> wildmenumode() ? "\<C-n>" : "\<Down>"
cnoremap <expr> <Up> wildmenumode() ? "\<C-p>" : "\<Up>"
