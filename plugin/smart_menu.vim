" vim/plugin/smart_menu.vim
scriptencoding utf-8

let s:main_menu = [
      \ 'Run',
      \ ]

" Submenu definitions
let s:run_menu = ['Line', 'Visual', 'Buffer']

function! s:ShowMenu(items, callback)
  let options = {
	\ 'callback': a:callback,
	\ 'pos': 'botleft',
	\ 'line': 'cursor-1',
	\ 'col': 'cursor',
	\ 'title': 'Smart Menu',
	\ 'border': [],
	\ 'padding': [0,1,0,1],
	\ 'borderhighlight': ['String'],
	\ 'borderchars': ['─', '│', '─', '│', '╭', '╮', '╯', '╰'],
	\ }
  call popup_menu(a:items, options)
endfunction

nnoremap <localleader>, :call <SID>ShowMainMenu()<CR>

function! s:ShowMainMenu()
  let context_menu = s:GetContextMenu()
  let menu = extend(copy(s:main_menu), context_menu)
  call s:ShowMenu(menu, function('s:HandleMainChoice'))
endfunction

function! s:GetContextMenu()
  let context_menu = []
  if &filetype ==# 'python'
    call add(context_menu, 'Run Python File')
  elseif &filetype ==# 'sh'
    call add(context_menu, 'Run Shell Script')
  endif
  return context_menu
endfunction

function! s:HandleMainChoice(id, choice)
  if a:choice == -1 | return | endif
  let context_menu = s:GetContextMenu()
  let full_menu = extend(copy(s:main_menu), context_menu)
  let option = full_menu[a:choice - 1]
  if option ==# 'Run' | call s:ShowMenu(s:run_menu, function('s:HandleRunMenu'))
  " elseif option == 'File Operations'
  "   call s:ShowMenu(s:file_menu, function('s:HandleFileMenu'))
  " elseif option == 'Code Navigation'
  "   call s:ShowMenu(s:code_menu, function('s:HandleCodeMenu'))
  " elseif option == 'Text Manipulation'
  "   call s:ShowMenu(s:text_menu, function('s:HandleTextMenu'))
  " elseif option == 'Vim Info'
  "   call s:ShowMenu(s:info_menu, function('s:HandleInfoMenu'))
  " elseif option == 'Run Commands'
  "   call s:ShowMenu(s:run_menu, function('s:HandleRunMenu'))
  " elseif option == 'Formatting'
  "   call s:ShowMenu(s:format_menu, function('s:HandleFormatMenu'))
  " elseif option == 'Tmux Integration'
  "   call s:ShowMenu(s:tmux_menu, function('s:HandleTmuxMenu'))
  " elseif option == 'Run Python File' || option == 'Run Shell Script'
  "   call run#file()
  endif
endfunction

function! s:HandleRunMenu(id, choice)
  if a:choice == -1 | return | endif
  let option = s:run_menu[a:choice - 1]
  if option ==# 'Line'	      |  call run#line()
  elseif option ==# 'Visual'  |  call run#visual()
  elseif option ==# 'Buffer'  |  call run#buffer()
  endif
endfunction

" function! s:HandleFileMenu(id, choice)
"   if a:choice == -1 | return | endif
"   let option = s:file_menu[a:choice - 1]
"   if option == 'Run File'
"     call run#file()
"   elseif option == 'Run File with Args'
"     call inputsave()
"     let args = input('Enter arguments: ')
"     call inputrestore()
"     call run#file_with_args(args)
"   elseif option == 'Make'
"     Make
"   elseif option == 'Generate CTags'
"     Ctags
"   endif
" endfunction

" function! s:HandleCodeMenu(id, choice)
"   if a:choice == -1 | return | endif
"   let option = s:code_menu[a:choice - 1]
"   if option == 'Goto Definition'
"     execute "normal! \<C-]>"
"   elseif option == 'Find References'
"     execute "normal! g\<C-]>"
"   endif
" endfunction

" function! s:HandleTextMenu(id, choice)
"   if a:choice == -1 | return | endif
"   let option = s:text_menu[a:choice - 1]
"   if option == 'Remove Trailing Whitespace'
"     call format#remove_trailing_whitespace()
"   elseif option == 'Create Hyperlink'
"     call utils#hyperlink()
"   elseif option == 'Replace Selection'
"     call utils#replace_selection()
"   endif
" endfunction

" function! s:HandleInfoMenu(id, choice)
"   if a:choice == -1 | return | endif
"   let option = s:info_menu[a:choice - 1]
"   if option == 'Highlight Group'
"     call info#highlight_group()
"   elseif option == 'Syntax Group'
"     call info#syntax_group()
"   elseif option == 'Get Vim Info'
"     call info#get()
"   endif
" endfunction

" function! s:HandleFormatMenu(id, choice)
"   if a:choice == -1 | return | endif
"   let option = s:format_menu[a:choice - 1]
"   if option == 'Format Buffer'
"     Fmt
"   elseif option == 'Format Selection'
"     '<,'>call format#buffer()
"   endif
" endfunction

" Key mapping to show the menu
