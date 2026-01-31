if !exists('g:chezmoi#source_dir_path')
  finish
endif

augroup chezmoi
  autocmd!
  " automatically `chezmoi add` aliases and binfiles
  au BufWritePost ~/.bash_aliases,~/bin/* silent! execute '!chezmoi add "%" --no-tty >/dev/null 2>&1' | redraw!

  " immediately `chezmoi apply` changes when writing to a chezmoi file
  exe printf('au BufWritePost %s/* silent! !chezmoi apply --force --source-path "%%"', g:chezmoi#source_dir_path)
augroup END
