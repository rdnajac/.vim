function! s:notify_reload(filetype) abort
  echohl InfoMsg
  echom 'Preparing to reload ftplugin for: ' . a:filetype
  echohl None
endfunction

function! s:reload_ftplugin(filetype) abort
  execute 'bufdo if &ft == "' . a:filetype . '" | set ft=' . a:filetype . ' | endif'
endfunction

augroup ReloadFTPlugin
  autocmd!
  autocmd BufWritePost */ftplugin/* call s:notify_reload(expand("<afile>:t:r"))
  autocmd BufWritePost */ftplugin/* call s:reload_ftplugin(expand("<afile>:t:r"))
augroup END
