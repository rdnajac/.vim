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

echom vimline#flags()
