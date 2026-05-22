if !exists('g:chezmoi#source_dir_path') || !executable('chezmoi')
  finish
endif

augroup chezmoi
  autocmd!
  au BufWritePost ~/.bash_aliases execute '!chezmoi add %'
  au BufWritePost */dot_config/*  execute '!chezmoi apply --source-path %'
augroup END
