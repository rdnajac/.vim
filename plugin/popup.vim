" vim/plugin/popup.vim
scriptencoding utf-8
if exists('g:loaded_popup')
  finish
endif
let g:loaded_popup = 1

let g:popup_options = {
      \ 'hidden': v:true,
      \ 'border': [1, 1, 1, 1],
      \ 'borderhighlight': ['String'],
      \ 'borderchars': ['─', '│', '─', '│', '╭', '╮', '╯', '╰'],
      \ 'line': (&lines - 2),
      \ 'close': 'click',
      \ }

function! g:PopupNotify() abort
  let popid = popup_create('Hello, world!', g:popup_options)
  call popup_show(popid) 
endfunction

function! g:PopupShow(text) abort
    let popid = popup_create(a:text, g:popup_options)
    call popup_show(popid)
endfunction
