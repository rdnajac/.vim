augroup ReloadFTPlugin
  autocmd!
  " Watch for any .vim files in ftplugin directory using vim#home() dynamically
  autocmd BufWritePost {vim#home()}/ftplugin/*.vim call ReloadFiletypeBuffers(expand("<afile>:t:r"))
augroup END

function! ReloadFiletypeBuffers(filetype)
  for buf in range(1, bufnr('$'))
    if getbufvar(buf, '&filetype') == a:filetype
      execute 'filetype ' . a:filetype
    endif
  endfor
endfunction
