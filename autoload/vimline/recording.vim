function! s:subarrows(str) abort
  let ret = a:str
  let mydict = {'<Up>':' ', '<Down>':' ', '<Left>':' ', '<Right>':' '}
  for [k,v] in items(mydict)
     execute $"let ret = substitute(ret, '{k}', '{v}', 'g')"
  endfor
  return ret
endfunction

function! vimline#recording#() abort
  let rec = reg_recording()
  if empty(rec) && !exists('g:vimline_last_reg')
    return ''
  endif

  let reg = empty(rec) ? g:vimline_last_reg : rec
  let icon = empty(rec) ? '@' : '󰑋'

  " Get and sanitize register contents
  let contents = getreg(reg)
  let contents = escape(contents, '%\|')
  let contents = keytrans(contents)
  let contents = substitute(contents, ' ', '<SPACE>', 'g')
  let contents = s:subarrows(contents)

  return printf('%s [%s%s] ', contents, icon, reg)
endfunction

let g:contents = getreg('Z')
echom contents

augroup vimline_recording
  autocmd!
  " clear the register
  " autocmd VimEnter * Info getreg('0')
  " autocmd VimEnter * setreg('0', '')
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
