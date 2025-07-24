function! vimline#recording() abort
  let rec = reg_recording()
  let reg = empty(rec) ? get(g:, 'vimline_last_reg', 'q') : rec
  let icon = empty(rec) ? '@' : '󰑋'
  let ret = '[' . icon . reg . '] '
  if empty(rec)
    let macro = escape(keytrans(getreg(reg)), '%\|')
    return ret . macro . ' '
  endif
  return ret
endfunction

function! vimline#tabline() abort
  let l:line = ''
  let l:line .= '%#Chromatophore_c# '
  let l:line .= vimline#components#docsymbols()
  let l:line .= '%#Normal#'
  return l:line
endfunction

function! vimline#flags() abort
  let l:line = ''
  let l:line .= vimline#icons#filetype()
  let l:line .= vimline#icons#copilot()
  let l:line .= vimline#icons#treesitter()
  let l:line .= vimline#icons#lsp()
  let l:line .= vimline#icons#modified()
  let l:line .= vimline#icons#help()
  let l:line .= vimline#icons#readonly()
  return l:line
endfunction
