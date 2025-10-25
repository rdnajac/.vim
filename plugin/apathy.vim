if exists('g:loaded_apathy')
  finish
endif
let g:loaded_apathy = v:true

" vim sets defaults that are only useful for C/C++
if !has('nvim')
  setglobal define=
  setglobal include=
  setglobal includeexpr=
  setglobal path=.,,
endif

