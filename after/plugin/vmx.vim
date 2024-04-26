" vim: fdm=marker
 
function! Vmx(cmd) abort
  call VimuxRunCommand(a:cmd)
endfunction

" helper functions {{{
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

function! VmxPy() abort
  VimuxRunCommand('cd ' . s:thisdir() . ' && ' . 'python3 ' . s:thisfile())
endfunction
" }}}

" dune build {{{
function VmxDB() abort
  VimuxRunCommand('dune build')
endfunction

function VmxDBhere() abort
  VimuxRunCommand('cd ' . s:thisdir() . ' && dune build')
endfunction

function! VmxDBroot() abort
  VimuxRunCommand('cd ' . s:reporootdir() . ' && dune build')
endfunction
" }}}

function! VmxLine() abort
  call Vmx(getline('.'))
endfunction

" function! VmxSh() abort
"   " execute the file with ./ prefixed to the absolute path, don't cd
"   cmd = ''
"   absolute_path = s:thisfile()

" vmx keybindings
let localleader = "\\" 
nnoremap <localleader>p :<C-u>call VimuxPromptCommand()<CR>
nnoremap <localleader><localleader> :<C-u>call VimuxRunLastCommand()<CR>
nnoremap <localleader>ll :<C-u>call VmxLine()<CR>
"nnoremap <localleader>r :<C-u>call Vmx(@")<CR> 
"nnoremap <localleader><localleader> :<C-u>call VimuxPromptCommand()<CR>
"vnoremap <localleader><localleader> :<C-u>call VmxVisualLine()<CR>
xnoremap <localleader><localleader> :<C-u>call VmxVisualLine()<CR>
nnoremap <localleader>o :<C-u>call VimuxOpenRunner()<CR>

function! VmxFile() abort
  let l:dir = expand('%:p:h')
  let l:file = expand('%:p')
  call Vmx('cd ' . l:dir . ' && ' . l:file)
endfunction
nnoremap <localleader>x :<C-u>call VmxFile()<CR>

" run selection

nnoremap <localleader>db :<C-u>call VmxDB()<CR>
nnoremap <localleader>.db :<C-u>call VmxDBhere()<CR> 
nnoremap <localleader>rdb :<C-u>call VmxDBroot()<CR>
 
 
nnoremap <C-l> :<C-u>call VmxLine()<CR>
nnoremap <C-.> :<C-u>call VimuxRunLastCommand()<CR> 

nnoremap <leader>p :<C-u>call VimuxPromptCommand<CR>
nnoremap <leader>vp :<C-u>call VimuxPromptCommand<CR>
nnoremap <leader>vr :<C-u>call VimuxRunLastCommand()<CR>
nnoremap <leader>vl :<C-u>call VmxLine()<CR>
nnoremap <leader>vpy :<C-u>call VimuxRunCommand('python3 ' . s:thisfile())<CR>
nnoremap <leader>vmx :<C-u>call VimuxOpenRunner()<CR>
nnoremap <leader>vdb :<C-u>call VmxDB()<CR>
