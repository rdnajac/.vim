" let g:chezmoi#use_tmp_buffer = 1
let g:chezmoi#source_dir_path =
      \ exists('$CHEZMOI_SOURCE_DIR')
      \ ? expand('$CHEZMOI_SOURCE_DIR')
      \ : expand('~/.local/share/chezmoi')

function s:apply()
  execute '!chezmoi apply --source-path ' . expand('%')
  echo 'Applied chezmoi changes to ' . expand('%')
endfunction

augroup chezmoi
  autocmd!
  autocmd BufWritePost ~/.local/share/chezmoi/* ! chezmoi apply --source-path "%"
  autocmd BufWritePost ~/.bash_aliases ! chezmoi add "%"
augroup END
