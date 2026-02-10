if !exists('g:chezmoi#source_dir_path') || !executable('chezmoi')
  finish
endif

function! s:chezmoi_add() abort
  Info 'Adding "' . expand('%') . '" to chezmoi...'
  silent! execute '!chezmoi add "' . expand('%') . '" --no-tty >/dev/null 2>&1'
  redraw!
endfunction

function! s:chezmoi_apply() abort
  silent! execute '!chezmoi apply --force --source-path "' . expand('%') . '"'
endfunction

augroup chezmoi
  autocmd!
  au BufWritePost ~/.bash_aliases call s:chezmoi_add()
  au BufWritePost ~/bin/* call s:chezmoi_add()
  exe printf('au BufWritePost %s/* call s:chezmoi_apply()', g:chezmoi#source_dir_path)
augroup END
