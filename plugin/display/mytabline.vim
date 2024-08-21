" Define a global dictionary to map filetypes to emojis
let g:filetype_emojis = {
	    \ 'py':       '🐍',
	    \ 'sh':       '🐚',
	    \ 'vim':      '🛠️',
	    \ 'markdown': '📜',
	    \ 'html':     '🌐',
	    \ 'css':      '🎨',
	    \ 'R':        '📊',
	    \ }

let s:modified = '📝'

function! s:get_filetype_emoji(buf) abort
  if getbufvar(a:buf, "&modified")
		return s:modified
  else 
    return get(g:filetype_emojis, getbufvar(a:buf, "&filetype"), '💾')
endfunction

function! s:get_filename(buf) abort
    let filename = fnamemodify(bufname(a:buf), ':t')
    return filename != '' ? filename : '[∅]'
endfunction

function! MyTabline() abort
    let line = ''
    let current_buf = bufnr('%')
    for buf in filter(range(1, bufnr('$')), 'buflisted(v:val)')
	let s = '%' . buf . 'T' . (buf == current_buf ? '%#TabLineSel#' : '%#TabLine#')
	let s .= ' ' . s:get_filetype_emoji(buf) .  ' ' . s:get_filename(buf) . ' ' 
	" now add the section to the tabline
	let line .= s
    endfor
    return line . '👾'
endfunction

set tabline=%!MyTabline()
set showtabline=2
