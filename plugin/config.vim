let g:eunuch_interpreters = {
      \ '.':      '/bin/sh',
      \ 'sh':     'bash',
      \ 'bash':   'bash',
      \ 'lua':    'nvim -l',
      \ 'python': 'python3',
      \ 'r':      'Rscript',
      \ 'rmd':    'Rscript',
      \ 'zsh':    'zsh',
      \ }

" Set quickfix method based on whether `pplatex` is executable
let g:vimtex_quickfix_method = executable('pplatex') ? 'pplatex' : 'latexlog'

" use vimtex's built-in formatexpr
let g:vimtex_format_enabled = 1

" Disable vimtex mapping for `K` in normal mode
let g:vimtex_mappings_disable = {'n': ['K']}

if exists('g:chezmoi#source_dir_path')
  Info 'we good'
  " let g:chezmoi#source_dir_path = expand('~/.local/share/chezmoi')
  let g:chezmoi#use_tmp_buffer = 1

  augroup chezmoi
    autocmd!
    " Automatically `chezmoi add` aliases and binfiles
    au BufWritePost ~/.bash_aliases,~/bin/* sil! exe
	  \ '!chezmoi add "%" --no-tty >/dev/null 2>&1' | redr!
    " Immediately `chezmoi apply` changes when writing to a chezmoi file
    exec 'au BufWritePost '.g:chezmoi#source_dir_path.'/* ' .
	  \ '!chezmoi apply --force --no-tty --source-path "%"'
  augroup END
endif
