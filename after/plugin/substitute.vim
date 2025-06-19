" https://gist.github.com/romainl/b00ccf58d40f522186528012fd8cd13d
function! Substitute(type, ...)
	let cur = getpos("''")
	call cursor(cur[1], cur[2])
	let cword = expand('<cword>')
	execute "'[,']s/" . cword . "/" . input(cword . '/')
	call cursor(cur[1], cur[2])
endfunction
" go substitue
nmap <silent> gs m':set opfunc=Substitute<CR>g@
" Usage:
"   <key>ipfoo<CR>         Substitute every occurrence of the word under
"                          the cursor with 'bar' in the current paragraph
"   <key>Gbar<CR>          Diff, fprom here to the end of the buffer
"   <key>?bar<CR>bar<CR>   Diff, from previous occurrence of 'bar'
"                          to current line

"   <key>ipbar<CR>         Substitute every occurrence of the word under
"                          the cursor with 'bar' in the current paragraph
"   <key>Gbar<CR>          Diff, fprom here to the end of the buffer
"   <key>?bar<CR>bar<CR>   Diff, from previous occurrence of 'bar'
"                          to current line
