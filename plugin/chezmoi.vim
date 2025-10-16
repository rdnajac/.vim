if !exists('g:chezmoi#source_dir_path')
  let g:chezmoi#source_dir_path = expand('~/.local/share/chezmoi')
endif
let g:chezmoi#use_tmp_buffer = 1

augroup chezmoi
  autocmd!
  " Automatically `chezmoi add` aliases and binfiles
  au BufWritePost ~/.bash_aliases,~/bin/* sil! exe '!chezmoi add "%" --no-tty >/dev/null 2>&1' | redr!
  " Immediately `chezmoi apply` changes when writing to a chezmoi source file
  exec 'au BufWritePost '.g:chezmoi#source_dir_path.'/* ' .
	\ '!chezmoi apply --force --no-tty --source-path "%"'
augroup END
