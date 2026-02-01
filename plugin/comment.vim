" delete/yank comment
nmap dc dgc
nmap yc ygc

" TODO: make this an opfunc
nmap gy "xyygcc"xp<Up>
nmap gY "xyygcc"xP

" toggle comment line
nmap vv Vgc

" don't capture whitespace in `gc`
nmap gcap gcip

let s:comments = {
      \ 'o': '',
      \ 'b': 'BUG: ',
      \ 'f': 'FIXME: ',
      \ 'h': 'HACK: ',
      \ 'n': 'NOTE: ',
      \ 'p': 'PERF: ',
      \ 't': 'TODO: ',
      \ 'x': 'XXX: ',
      \ 'i': 'stylua: ignore',
      \ }

" map `co` and `cO` to insert comments with specific tags
for [key, val] in items(s:comments)
  execute printf('nmap co%s :call comment#below("%s")<CR>', key, val)
  execute printf('nmap cO%s :call comment#above("%s")<CR>', key, val)
  execute printf('nmap co%s :call comment#above("%s")<CR>', toupper(key), val)
endfor

if has('nvim')
  finish
endif

" BUG: still does not work with the version of vim on homebrew
" VIM - Vi IMproved 9.1 (2024 Jan 02, compiled Oct 12 2025 14:37:02)
" macOS version - arm64
" Included patches: 1-1850

packadd comment
" see `:h package-comment`
" issue: https://github.com/vim/vim/issues/14171
" commit: https://github.com/vim/vim/commit/fa6300872732f80b770a768e785ae2b189d3e684
" suspect: import autoload 'comment.vim'
" HACK: manually sourcing this resolves E1041 `Toggle`
source $VIMRUNTIME/pack/dist/opt/comment/autoload/comment.vim
