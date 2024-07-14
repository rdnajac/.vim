" functions to get information about text selections

function! info#HighlightGroup() abort
    echo synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
" TODO: why not " :echo synIDattr(synID(line("."), col("."), 1), "name")
" TODO print a more informative message
" TODO: popup window?
endfunction

function! info#SyntaxGroup() abort
	echo synIDtrans(synID(line('.'), col('.'), 0))
endfunction
