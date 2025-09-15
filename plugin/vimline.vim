" TODO: move to col.vim or something
" set foldcolumn=1
set signcolumn=number
" set numberwidth=3

let &laststatus = has('nvim') ? 3 : 2
set statusline=%!vimline#statusline#()

if !has('nvim')
  finish
endif

" set winbar=%{%vimline#winbar#()%}
set winbar=v:lua.require'nvim.ui.winbar'
" TODO: move to nv.ui
" set statuscolumn=%!vimline#statuscolumn#()
" set statuscolumn=%!v:lua.require'vimline.statuscolumn'()
" set statuscolumn=%{if(&number,printf('%4d',v:lnum),repeat(' ',4)).'│'}

finish
" TODO: set this up with recording component
augroup vimline
  autocmd!
  " Keep the recording component up to date
  autocmd RecordingEnter * let g:vimline_rec_reg = reg_recording()
  autocmd RecordingLeave * let g:vimline_last_reg = get(g:, 'vimline_rec_reg', '') | unlet g:vimline_rec_reg
  autocmd RecordingEnter,RecordingLeave * redrawstatus
augroup END
