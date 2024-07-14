"https://web.archive.org/web/20230418005002/https://www.vi-improved.org/recommendations/
function! format#remove#trailing_whitespace() abort
    if !&binary && &filetype != 'diff'
	let size = line2byte(line('$') + 1) - 1
	normal mz
	normal Hmy
	%s/\s\+$//e
	normal 'yz<CR>
	normal z
	let final_size = line2byte(line('$') + 1) - 1
	if final_size != size
	    echomsg "Stripped " . (size - final_size) . " bytes of trailing whitespace."
	endif
    endif
endfunction
