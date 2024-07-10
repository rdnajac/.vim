" .vim/after/ftplugin/markdown.vim
" setlocal foldlevel=3

" snippets {{{1
" headers {{{2
inoremap <buffer> `1 #<Space>
inoremap <buffer> `2 ##<Space>
inoremap <buffer> `3 ###<Space>
inoremap <buffer> `4 ####<Space>
inoremap <buffer> `5 #####<Space>
inoremap <buffer> `6 ######<Space>

" fenced code blocks {{{2
inoremap <buffer> `` ```<CR><CR>```<Up>
inoremap <buffer> `c ```c<CR><CR>```<Up>
inoremap <buffer> `p ```python<CR><CR>```<Up>
inoremap <buffer> `s ```sh<CR><CR>```<Up>
inoremap <buffer> `t ```text<CR><CR>```<Up>
inoremap <buffer> `v ```vim<CR><CR>```<Up>

" }}}1
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

let g:markdown_fenced_languages = ['bash=sh', 'c', 'python', 'vim']
let b:markdownlint_options = '--disable MD013'
let b:ale_fix_on_save = 1
let b:ale_markdown_markdownlint_options = b:markdownlint_options

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
" compile markdown preview
" call mkdp#util#install()
" let g:mkdp_page_title = '${name}'
"nnoremap <leader>md :MarkdownPreview<cr>

