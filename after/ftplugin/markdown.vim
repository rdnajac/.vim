" .vim/after/ftplugin/markdown.vim
" setlocal textwidth=80
let g:markdown_folding = 1
function! s:prettier() abort
  let l:pos = getpos(".")
  let l:w = winsaveview()
  silent execute '!prettier --write ' . shellescape(expand('%'))
  silent! edit!
  call setpos('.', l:pos)
  call winrestview(l:w)
  redraw!
  normal! zo
endfunction

" augroup PrettierOnSave
"     autocmd!
"     autocmd BufWritePre *.md call s:prettier()
" augroup END


inoremap <buffer> <localleader>1 #<Space>
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

inoremap <buffer> <localleader>fo <!-- {{{ -->
inoremap <buffer> <localleader>fc <!-- }}} -->
inoremap <buffer> <localleader>f1 <!-- {{{1 -->
inoremap <buffer> <localleader>f2 <!-- {{{2 -->
inoremap <buffer> <localleader>f3 <!-- {{{3 -->
inoremap <buffer> <localleader>f4 <!-- {{{4 -->
inoremap <buffer> <localleader>f5 <!-- {{{5 -->
inoremap <buffer> <localleader>f6 <!-- {{{6 -->

nnoremap <buffer> <localleader>fo A<Space><!-- {{{ -->
nnoremap <buffer> <localleader>fc A<Space><!-- }}} -->
nnoremap <buffer> <localleader>f1 A<Space><!-- {{{1 -->
nnoremap <buffer> <localleader>f2 A<Space><!-- {{{2 -->
nnoremap <buffer> <localleader>f3 A<Space><!-- {{{3 -->
nnoremap <buffer> <localleader>f4 A<Space><!-- {{{4 -->
nnoremap <buffer> <localleader>f5 A<Space><!-- {{{5 -->
nnoremap <buffer> <localleader>f6 A<Space><!-- {{{6 -->

inoremap <buffer> <! <!--<Space>--><Left><Left><Left><Left><Space>


" TODO set up compiler
let b:markdownlint_options = '--disable MD013'

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

" markdown preview 
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

