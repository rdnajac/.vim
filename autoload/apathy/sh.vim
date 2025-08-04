function! apathy#sh#setup() abort
  call apathy#Prepend('path', apathy#EnvSplit($PATH))
  setlocal include=^\\s*\\%(\\.\\\|source\\)\\s
  setlocal define=\\<\\%(\\i\\+\\s*()\\)\\@=
endfunction
