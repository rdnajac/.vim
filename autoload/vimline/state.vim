" pack/vimfect/start/vimline.nvim/autoload/vimline/state.vim
scriptencoding=utf-8
function! vimline#state#recording() abort
  let rec = reg_recording()
  let reg = empty(rec) ? get(g:, 'vimline_last_reg', 'q') : rec
  let icon = empty(rec) ? '@' : '󰑋'
  let ret = '[' . icon . reg . '] '
  " if empty(rec)
  "   let macro = escape(keytrans(getreg(reg)), '%\|')
  "   return ret . macro . ' '
  " endif
  return ret
endfunction
