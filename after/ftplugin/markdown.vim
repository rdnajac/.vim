" .vim/after/ftplugin/markdown.vim
setlocal spell spelllang=en_us 
" setlocal textwidth=80

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

augroup PrettierOnSave
    autocmd!
    autocmd BufWritePre *.md call s:prettier()
augroup END

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


if exists(":Tabularize")
    nmap <buffer> <localleader>t :Tabularize <Bar><CR>
    vmap <buffer> <localleader>t :Tabularize <Bar><CR>
endif

" headers {{{3
inoremap <buffer> <localleader>1 #<Space>
inoremap <buffer> <localleader>2 ##<Space>
inoremap <buffer> <localleader>3 ###<Space>
inoremap <buffer> <localleader>4 ####<Space>
inoremap <buffer> <localleader>5 #####<Space>
inoremap <buffer> <localleader>6 ######<Space>

" fenced code blocks {{{3
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

inoremap <buffer> <! <!--<Space>--><Left><Left><Left><Left><Space>

function! JumpToNextHeading(direction, count) " {{{
" https://gist.github.com/romainl/ac63e108c3d11084be62b3c04156c263
    let col = col(".")
    silent execute a:direction == "up" ? '?^#' : '/^#'
    if a:count > 1
        silent execute "normal! " . repeat("n", a:direction == "up" && col != 1 ? a:count : a:count - 1)
    endif
    silent execute "normal! " . col . "|"
    unlet col
endfunction " }}}
nnoremap <buffer> <silent> [[ :<C-u>call JumpToNextHeading("up",   v:count1)<CR>
nnoremap <buffer> <silent> ]] :<C-u>call JumpToNextHeading("down", v:count1)<CR>

nnoremap <leader>st i~~<Esc>A~~<Esc>


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

setlocal foldmethod=expr
setlocal foldtext=s:MyFoldText()
setlocal foldexpr=s:MyFoldLevel()

" markdown preview 
" call mkdp#util#install()
let g:mkdp_page_title = '${name}'
nnoremap <buffer> <localleader>md :MarkdownPreview<cr>

