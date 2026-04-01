" set completeopt=menu,preview,longest " see `:h |cmdline-completion|.`
" set completeopt+=preinsert
" More info here: |cmdline-completion|; default: `wildmode=full`
set wildmode=longest,full    " 1 First press: longest common substring, Second press: full match
" set wildmode=longest:full,full " Same as above, but cycle through the first patch ('preinsert'?)
" set wildmode=longest,list    " First press: longest common substring, Second press: list all matches
" set wildmode=noselect:full   " Show 'wildmenu' without selecting, then cycle full matches
" set wildmode=noselect:lastused,full " Same as above, but buffer matches are sorted by time last used

" NOTE: After navigating command-line history, the first call to
" wildtrigger() is a no-op; a second call is needed to start expansion.
" This is to support history navigation in command-line autocompletion.
" autocmd CmdlineChanged [:\/\?] call wildtrigger()

" navigate completion menu with arrow keys
cnoremap <expr> <Down> wildmenumode() ? "\<C-n>" : "\<Down>"
cnoremap <expr> <Up>   wildmenumode() ? "\<C-p>" : "\<Up>"

" autocomplete
" imap / /<C-x><C-f><C-n>
" imap <expr> <Tab> pumvisible() ? <C-y> : <Tab>

nnoremap ?? :verbose set ?<Left>
cnoreabbrev ?? verbose set ?<Left>
cnoreabbrev !! !./%
cnoreabbrev <expr> %% expand('%:p:h')

function! s:singlequote(str)
  return "'"..substitute(copy(a:str), "'", "''", 'g').."'"
endfunction

function! s:cabbrev(lhs, rhs)
  " execute printf( 'cnoreabbrev <expr> %s (getcmdtype() ==# ":" && getcmdline() =~# "%s") ? "%s" : "%s"',
  execute printf('cabbrev <expr> %s (getcmdtype() == ":" && getcmdpos() <= %d) ? %s : %s',
	\ a:lhs, 1+len(a:lhs), s:singlequote(a:rhs), s:singlequote(a:lhs))
endfunction

call s:cabbrev('vv', 'verbose')
call s:cabbrev('vvn', 'verbose nmap')
call s:cabbrev('vvx', 'verbose xmap')
call s:cabbrev('vvc', 'verbose cmap')
call s:cabbrev('vvi', 'verbose imap')
call s:cabbrev('vvt', 'verbose tmap')
call s:cabbrev('scp', '!scp %')
call s:cabbrev('m', 'Man')
call s:cabbrev('f', 'find')
" call s:cabbrev('p', 'lua Snacks.picker.()<Left><Left>')
nnoremap <leader>p :lua Snacks.picker.()<Left><Left>

set findfunc=Find
function! Find(arg, _)
  if empty(s:filescache)
    let s:filescache = globpath(git#root(), '**', 1, 1)
    call filter(s:filescache, '!isdirectory(v:val)')
    call map(s:filescache, "fnamemodify(v:val, ':.')")
  endif
  return a:arg == '' ? s:filescache : matchfuzzy(s:filescache, a:arg)
endfunc
let s:filescache = []
autocmd CmdlineEnter : let s:filescache = []
