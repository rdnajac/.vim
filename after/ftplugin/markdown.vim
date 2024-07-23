" after/ftplugin/markdown.vim
" setlocal textwidth=80

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

" setlocal foldmethod=expr
" setlocal foldtext=s:MyFoldText()
" setlocal foldexpr=s:MyFoldLevel()

" call mkdp#util#install()
let g:mkdp_page_title = '${name}'
nnoremap <buffer> <localleader>md :MarkdownPreview<cr>

if exists(":Tabularize") " {{{
  nmap <buffer> <localleader>t :Tabularize <Bar><CR>
  vmap <buffer> <localleader>t :Tabularize <Bar><CR>

  " https://gist.github.com/287147
  function! s:align()
    let p = '^\s*|\s.*\s|\s*$'
    if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
      let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
      let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
      Tabularize/|/l1
      normal! 0
      call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
    endif
  endfunction
  inoremap <buffer> <silent> <Bar>   <Bar><Esc>:call <SID>align()<CR>a
endif
" vim: nofoldenable
