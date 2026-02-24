if !exists('g:chezmoi#source_dir_path') || !executable('chezmoi')
  finish
endif

function! s:chezmoi_apply() abort
  silent! execute '!chezmoi apply --force --source-path "' . expand('%') . '"'
endfunction

augroup chezmoi
  autocmd!
  " exe printf('au BufWritePost %s/* call s:chezmoi_apply()', g:chezmoi#source_dir_path)
  " automatically `chezmoi add` files on write, even if not `chezmoi edit`ed
  au BufWritePost ~/.bash_aliases,~/bin/* execute '!chezmoi add % --no-pager --no-tty'
augroup END
