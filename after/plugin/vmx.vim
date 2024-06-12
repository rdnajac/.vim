function! Vmx(cmd) abort
  call VimuxRunCommand(a:cmd)
endfunction

function! s:thisline()
  return getline('.')
endfunction

function! s:thisfile()
  return expand('%:p')
endfunction

function! s:thisdir()
  return expand('%:p:h')
endfunction

function! s:reporootdir()
  return system('git rev-parse --show-toplevel | xargs dirname')
endfunction

function! VmxLine() abort
  call Vmx(getline('.'))
endfunction

function! VmxFile() abort
  let l:dir = expand('%:p:h')
  let l:file = expand('%:p')
  call Vmx('cd ' . l:dir . ' && .' . l:file)
endfunction
nnoremap <localleader>x :<C-u>call VmxFile()<CR>

nnoremap <C-l> :<C-u>call VmxLine()<CR>
nnoremap <C-.> :<C-u>call VimuxRunLastCommand()<CR> 

nnoremap <leader>vp :<C-u>call VimuxPromptCommand<CR>
nnoremap <leader>vr :<C-u>call VimuxRunLastCommand()<CR>
nnoremap <leader>vl :<C-u>call VmxLine()<CR>
nnoremap <leader>vmx :<C-u>call VimuxOpenRunner()<CR>
nnoremap <leader>vdb :<C-u>call VmxDB()<CR>
