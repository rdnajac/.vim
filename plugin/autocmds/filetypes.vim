" autocmds/filetypes.vim
" Consolidate all filetype specific settings here

augroup myftplugin
  autocmd!
  autocmd FileType sh             setlocal sw=8 sts=8 noexpandtab wrap
  autocmd FileType c              setlocal sw=8 sts=8 noexpandtab
  autocmd FileType cpp,cuda       setlocal sw=4 sts=4   expandtab
  autocmd FileType python         setlocal sw=4 sts=4   expandtab fdm=indent
  autocmd FileType tex            setlocal sw=2 sts=2   expandtab fdm=syntax
  autocmd FileType vim,lua        setlocal sw=2 sts=2   expandtab fdm=marker
  autocmd FileType javascript     setlocal sw=2 sts=2   expandtab
  autocmd FileType html,css       setlocal sw=2 sts=2   expandtab
  autocmd FileType json,yaml,toml setlocal sw=2 sts=2   expandtab
  autocmd FileType * setlocal formatoptions+=j
  autocmd FileType * setlocal formatoptions-=o
  autocmd CmdwinEnter * quit
augroup END
