function! s:subarrows(str) abort
  let ret = a:str
  let mydict = {'<Up>':' ', '<Down>':' ', '<Left>':' ', '<Right>':' '}
  for [k,v] in items(mydict)
    execute $"let ret = substitute(ret, '{k}', '{v}', 'g')"
  endfor
  return ret
endfunction

function! s:subkeys(str) abort
  let ret = a:str
  let mydict = {'%':'%%', '\':'<Bslash>', '|':'<Bar>'}
  for [k,v] in items(mydict)
    execute $"let ret = substitute(ret, '{k}', '{v}', 'g')"
  endfor
  return ret
endfunction

function! s:sanitize_reg_contents(str) abort
  let contents = a:str
  let contents = keytrans(contents)
  let contents = s:subarrows(contents)
  let contents = s:subkeys(contents)
  return contents
endfunction

function! vimline#recording#() abort
  let rec = reg_recording()
  if empty(rec) && !exists('g:vimline_last_reg')
    return ''
  endif

  let reg = empty(rec) ? g:vimline_last_reg : rec
  let icon = empty(rec) ? '@' : '󰑋'

  let contents = s:sanitize_reg_contents(getreg(reg))

  " return printf('%%<%s [%s%s] ', contents, icon, reg)
  return printf('%s [%s%s] ', contents, icon, reg)
endfunction

augroup vimline_recording
  autocmd!
  " au VimEnter * call setreg('z', '')
  if exists('##RecordingEnter') && exists('##RecordingLeave')
    autocmd RecordingEnter *
	  \ let reg = reg_recording() |
	  \ if !exists('g:vimline_has_recorded') |
	  \   call setreg(reg, '') |
	  \   let g:vimline_has_recorded = 1 |
	  \ endif |
	  \ let g:vimline_rec_reg = reg
    autocmd RecordingLeave *
	  \ let g:vimline_last_reg = get(g:, 'vimline_rec_reg', '') |
	  \ unlet g:vimline_rec_reg
    autocmd RecordingEnter,RecordingLeave * redrawstatus
  endif
augroup END
