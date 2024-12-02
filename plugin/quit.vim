" Quit buffers smartly
cab qw  wqa!
cab wq  wqa!
cab Wq	wqa!
cab qW	wqa!
cab Qw	wqa!
cab WQ	wqa!
cab QW	wqa!
cab wqa wqa!
cab qwa wqa!
" TODO just use `:x`

cnoreabbrev <expr> X getcmdtype() == ':' && getcmdline() == 'X' ? 'x' : 'X'
cnoreabbrev <expr> Q getcmdtype() == ':' && getcmdline() == 'Q' ? 'q' : 'Q'

function! SmartQuit() abort
    if winnr('$') > 1
        bnext | 1wincmd w | q!
    else
        if len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) > 1
            bnext | bd# | 1wincmd w
        else
            quit!
        endif
    endif
endfunction

augroup quit_on_q
  autocmd!
  autocmd FileType help,qf,man
	\ silent! nnoremap <silent> <buffer> q :<C-U>close<CR> 
	\ | set nobuflisted
	\ | setlocal noruler
	\ | setlocal laststatus=0 
	\ | setlocal colorcolumn=
  " autocmd BufLeave * if empty(expand('%')) 
	" \ && empty(&buftype) && line('$') == 1 && getline(1) == '' 
  "       \ | execute 'bdelete!' | endif
augroup END
