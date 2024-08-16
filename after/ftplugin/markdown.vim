" after/ftplugin/markdown.vim
" setlocal textwidth=80
setlocal fdl=1
setlocal textwidth=80
setlocal noautoindent

" turn on markdown folding
let b:markdown_folding = 1

" Insert hyperlink from clipboard
vmap <buffer> <leader>k S]f]a()<Esc>hp

" Turn url into hyperlink
vmap <buffer> <localleader>k S)i[]<Left>

inoremap <buffer> <localleader>2 ##<Space>
inoremap <buffer> <localleader>3 ###<Space>
inoremap <buffer> <localleader>4 ####<Space>
inoremap <buffer> <localleader>5 #####<Space>
inoremap <buffer> <localleader>6 ######<Space>

inoremap <buffer> <localleader>c ```c<CR><CR>```<Up>
inoremap <buffer> <localleader>p ```python<CR><CR>```<Up>
inoremap <buffer> <localleader>s ```sh<CR><CR>```<Up>
inoremap <buffer> <localleader>t ```text<CR><CR>```<Up>
inoremap <buffer> <localleader>v ```vim<CR><CR>```<Up>

inoremap <buffer> <! <!--<Space>--><Left><Left><Left><Left><Space>

" increment/decrement headings with C-a and C-x
nnoremap <buffer> <C-a> :call IncHeading()<CR>
nnoremap <buffer> <C-x> :call DecHeading()<CR>

function! IncHeading()
	let line = getline('.')
	let level = len(matchstr(line, '^#\+'))
	if level < 6
		let new_line = substitute(line, '^#\+', repeat('#', level + 1), '')
		call setline('.', new_line)
	endif
endfunction

function! DecHeading()
	let line = getline('.')
	let level = len(matchstr(line, '^#\+'))
	if level > 1
		let new_line = substitute(line, '^#\+', repeat('#', level - 1), '')
		call setline('.', new_line)
	endif
endfunction

function! s:MyFoldLevel()
  return s:headingDepth(v:lnum) > 0 ? ">1" : "="
endfunction

function! s:headingDepth(lnum)
  return (s:isFenced(a:lnum) ? 0 : len(matchstr(getline(a:lnum), '^#\{1,6}')))
endfunction

function! s:isFenced(lnum)
  return (synIDattr(synID(a:lnum, 1, 1), "name") =~? 'markdownCodeBlock') ? 1 : 0
endfunction

function! s:MyFoldText()
  let level = s:headingDepth(v:foldstart)
  let indent = repeat('#', level)
  let title = substitute(getline(v:foldstart), '^#\+\s\+', '', '')
  let foldsize = (v:foldend - v:foldstart)
  let leading_spaces = (level < 6) ? repeat(' ', 6 - level) : ' '
  let title_width = strdisplaywidth(title)
  let trailing_spaces = (title_width < 40) ? repeat(' ', 40 - title_width) : ' '
  let linecount = '[' . foldsize . ' line' . (foldsize > 1 ? 's' : '') . ']'
  return indent . leading_spaces .title . trailing_spaces . linecount
endfunction

" call mkdp#util#install()
let g:mkdp_page_title = '${name}'
nnoremap <buffer> <localleader>md :MarkdownPreview<cr>
