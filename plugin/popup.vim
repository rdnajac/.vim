" popup
" popup_create({text}, {options})  
" popup_notification({text}, {options})
" popup_atcursor({text}, {options})
let s:popup_options = {
      \ 'hidden': v:true,
      \ 'border': [1, 1, 1, 1],
      \ 'borderhighlight': ['String'],
      \ 'borderchars': ['─', '│', '─', '│', '╭', '╮', '╯', '╰'],
      \ 'line': (&lines - 2),
      \ }

function! g:Popup_termcmd(cmd)
  popup_notification(system(a:cmd))
endfunction

function! Notify()
  let popid = popup_create('Hello, world!', s:popup_options)
  call popup_show(popid) 
endfunction
command! -nargs=0 Notify call Notify() 

function! Popup_cmd(cmd)
	let popid = popup_create(system(a:cmd), s:popup_options)
	call popup_show(popid)
endfunction
command! -nargs=1 Popup call Popup_cmd(<f-args>)

" Execute the current file and display the output in a popup window
function! VX()
  let cmd = './' . expand('%')
  call Popup(cmd, systemlist(cmd))
endfunction
" TODO turn this into a command with options

command! -nargs=0 VX call VX()
" popup_notification()
