if !has('nvim')
  finish
endif
let g:chezmoi#use_tmp_buffer = 1

function! s:chezmoi_add()
  silent! execute '!chezmoi add "%" --no-tty >/dev/null 2>&1' | redraw!
endfunction

augroup chezmoi
  autocmd!
  " Automatically add files to chezmoi when saved from outside of chezmoi
  autocmd BufWritePost ~/.bash_aliases,~/bin/* call s:chezmoi_add()
  " Apply chezmoi changes when files in chezmoi source directory are saved
  au BufWritePost ~/.local/share/chezmoi/* !chezmoi apply --source-path --force "%"
  exec 'au BufWritePost '.g:chezmoi#source_dir_path.'/* ' .
	\ '!chezmoi apply --force --no-tty --source-path "%"'

  autocmd FileType ghostty,ghostty.chezmoitmpl setlocal commentstring=#\ %s
augroup END
