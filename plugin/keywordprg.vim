" preserve the original K mapping
" NOTE: overridden in some filetypes below
nnoremap <leader>k <Cmd>normal! K<CR>

command! -nargs=* MyMan call s:mykeywordprg(<f-args>)
function! s:mykeywordprg(...) abort
  if !empty(b:manpage)
    let keyword = a:0 ? a:1 : expand('<cword>')
    " Info keyword
    execute 'Man' b:manpage
    call search(keyword)
  endif
endfunction

function! s:setup(...) abort
  let b:manpage = a:0 ? a:1 : &filetype
  setlocal keywordprg=:MyMan
  setlocal iskeyword+=-
endfunction

augroup vimrc.keywordprg
  autocmd!
  " au BufRead,BufNewFile *alacritty.*ml call s:setup('5 alacritty')
  au FileType ghostty,kitty,tmux call s:setup()
  au FileType sshconfig call s:setup('ssh')
  au FileType gitconfig,gitconfig.chezmoitmpl call s:setup('git-config(1)')
  au FileType lua setlocal keywordprg=:help iskeyword+=-
  au FileType sh  setlocal keywordprg=:Man  iskeyword-=_
  au FileType tex nnoremap <silent><buffer> <leader>K <Plug>(vimtex-doc-package)
  au FileType vim nnoremap <silent><buffer> <leader>K <Plug>ScripteaseHelp
augroup END
