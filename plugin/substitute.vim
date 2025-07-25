" https://gist.github.com/romainl/b00ccf58d40f522186528012fd8cd13d
function! Substitute(type, ...)
  let cur = getpos("''")
  call cursor(cur[1], cur[2])
  let cword = expand('<cword>')
  execute "'[,']s/" . cword . '/' . input(cword . '/')
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

" https://github.com/kaddkaka/vim_examples?tab=readme-ov-file#replace-only-within-selection
xnoremap s :s/\%V<C-R><C-W>/

" https://github.com/kaddkaka/vim_examples?tab=readme-ov-file#repeat-last-change-in-all-of-file-global-repeat-similar-to-g
nnoremap g. :%s//<c-r>./g<esc>

" " a global function with a distinct name
" function! BufSubstituteAll(find, replace) abort
"   " escape any slash or backslash in the arguments
"   let l:find    = escape(a:find,    '/\')
"   let l:replace = escape(a:replace, '/\')
"   " run the substitute in every buffer, then write if changed
"   execute 'bufdo %s/\V' . l:find . '/' . l:replace . '/g | update'
" endfunction
"
" " the user‐facing command calls that function
" command! -nargs=2 Sall call BufSubstituteAll(<f-args>)
