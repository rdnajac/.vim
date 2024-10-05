" vim/autoload/utils.vim
function! utils#lol() abort
  echom '>^.^<' | redraw
endfunction

function! utils#replaceSelection() abort
    normal! gv"xy
    let sel = getreg('x')
    let rep = input('Replace all instances of "' . sel . '" with: ')
    if rep != ''
      let cmd = ':%s/' . escape(sel, '/\') . '/' . escape(rep, '/\') . '/g'
      exe cmd
    endif
endfunction

function! utils#qf_set_signs() abort
  call sign_define('QFError',{'text':'💩'})
  call sign_unplace('*')
  let s:qfl = getqflist()
    for item in s:qfl
      call sign_place(0, '', 'QFError', item.bufnr, {'lnum': item.lnum})
    endfor
endfunction
