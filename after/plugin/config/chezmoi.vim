let g:chezmoi#use_tmp_buffer = 1
let g:chezmoi#source_dir_path =
      \ exists('$CHEZMOI_SOURCE_DIR')
      \ ? expand('$CHEZMOI_SOURCE_DIR')
      \ : fnameescape(system('chezmoi source-path'))

" --exclude=scripts

augroup chezmoi
  autocmd!
  " Automatically add files to chezmoi when saved from outside of chezmoi
  autocmd BufWritePost ~/.bash_aliases !chezmoi add "%"

  " Apply chezmoi changes when files in chezmoi source directory are saved
  " autocmd BufWritePost ~/.local/share/chezmoi/* !chezmoi apply --source-path "%"
  exec 'au BufWritePost ' . g:chezmoi#source_dir_path . '/* !chezmoi apply --source-path "%"'

augroup END
