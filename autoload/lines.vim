" ~/.vim/autoload/ui.vim
scriptencoding utf-8

let s:filetype_emojis = {
      \ 'py':       '🐍',
      \ 'sh':       '🐚',
      \ 'vim':      '🛠️',
      \ 'markdown': '📜',
      \ 'html':     '🌐',
      \ 'css':      '🎨',
      \ 'R':        '📊',
      \ }

let s:modified = '📝'

function! s:get_filetype_emoji(buf) abort
  if getbufvar(a:buf, '&modified')
    return s:modified
  else
    return get(s:filetype_emojis, getbufvar(a:buf, '&filetype'), '💾')
  endif
endfunction

function! s:get_filename(buf) abort
  let filename = fnamemodify(bufname(a:buf), ':t')
  return !empty(filename) ? filename : '[∅]'
endfunction

function! s:tabline() abort
  let line = ''
  let current_buf = bufnr('%')

  " Iterate over all listed buffers and create the tabline string
  for buf in filter(range(1, bufnr('$')), 'buflisted(v:val)')
    let s = '%' . buf . 'T' . (buf == current_buf ? '%#TabLineSel#' : '%#TabLine#')
    let s .= ' ' . s:get_filetype_emoji(buf) .  ' ' . s:get_filename(buf) . ' ' 
    let line .= s
  endfor

  return line . '👾'
endfunction

function! s:qf_signs() abort
  call sign_define('QFError',{'text':'💩'})
  call sign_unplace('*')
  let s:qfl = getqflist()
    for item in s:qfl
      call sign_place(0, '', 'QFError', item.bufnr, {'lnum': item.lnum})
    endfor
endfunction

autocmd QuickFixCmdPost [^l]* cwindow | silent! call s:qf_signs()
autocmd QuickFixCmdPost   l*  lwindow | silent! call s:qf_signs()

