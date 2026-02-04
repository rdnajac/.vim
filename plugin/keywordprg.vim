if exists('g:loaded_mykeywordprg')
  finish
endif
let g:loaded_mykeywordprg = 1

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
  let b:manpage = a:0 ? a:1 : &ft
  setlocal keywordprg=:MyMan
  setlocal iskeyword+=-
endfunction

augroup vimrc_keywordprg
  autocmd!
  au FileType ghostty,kitty,tmux call s:setup()
  au FileType gitconfig,gitconfig.chezmoitmpl call s:setup('git-config(1)')
  au FileType sshconfig call s:setup('ssh')
  " au BufRead,BufNewFile *alacritty.*ml call s:setup('5 alacritty')
  au FileType lua setlocal keywordprg=:help iskeyword+=-
  au FileType sh  setlocal keywordprg=:Man  iskeyword-=_
  au FileType tex nnoremap <silent><buffer> <leader>K <Plug>(vimtex-doc-package)
  au FileType vim nnoremap <silent><buffer> <leader>K <Plug>ScripteaseHelp
augroup END
