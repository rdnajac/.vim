" vim/plugin/smart_menu.vim

if exists('g:loaded_smart_menu') | finish | endif
let g:loaded_smart_menu = 1

let s:save_cpo = &cpo
set cpo&vim

" Main menu options
let s:main_menu = [
    \ 'File Operations',
    \ 'Code Navigation',
    \ 'Text Manipulation',
    \ 'Vim Info',
    \ 'Run Commands',
    \ 'Formatting',
    \ 'Tmux Integration'
    \ ]

" Submenu definitions
let s:file_menu = ['Run File', 'Run File with Args', 'Make', 'Generate CTags']
let s:code_menu = ['Goto Definition', 'Find References']
let s:text_menu = ['Remove Trailing Whitespace', 'Create Hyperlink', 'Replace Selection']
let s:info_menu = ['Highlight Group', 'Syntax Group', 'Get Vim Info']
let s:run_menu = ['Run Visual Selection as Shell Command', 'Run Visual Selection as VimScript']
let s:format_menu = ['Format Buffer', 'Format Selection']
let s:tmux_menu = ['Send to Tmux', 'Open Runner', 'Close Runner', 'Navigate Left', 'Navigate Down', 'Navigate Up', 'Navigate Right', 'Navigate Previous']

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

function! s:ShowMainMenu()
    let context_menu = s:GetContextMenu()
    let menu = extend(copy(s:main_menu), context_menu)
    call s:ShowMenu(menu, function('s:HandleMainChoice'))
endfunction

function! s:GetContextMenu()
    let context_menu = []
    if &filetype == 'python'
        call add(context_menu, 'Run Python File')
    elseif &filetype == 'sh'
        call add(context_menu, 'Run Shell Script')
    endif
    return context_menu
endfunction

function! s:HandleMainChoice(id, choice)
    if a:choice == -1 | return | endif
    let context_menu = s:GetContextMenu()
    let full_menu = extend(copy(s:main_menu), context_menu)
    let option = full_menu[a:choice - 1]
    if option == 'File Operations'
        call s:ShowMenu(s:file_menu, function('s:HandleFileMenu'))
    elseif option == 'Code Navigation'
        call s:ShowMenu(s:code_menu, function('s:HandleCodeMenu'))
    elseif option == 'Text Manipulation'
        call s:ShowMenu(s:text_menu, function('s:HandleTextMenu'))
    elseif option == 'Vim Info'
        call s:ShowMenu(s:info_menu, function('s:HandleInfoMenu'))
    elseif option == 'Run Commands'
        call s:ShowMenu(s:run_menu, function('s:HandleRunMenu'))
    elseif option == 'Formatting'
        call s:ShowMenu(s:format_menu, function('s:HandleFormatMenu'))
    elseif option == 'Tmux Integration'
        call s:ShowMenu(s:tmux_menu, function('s:HandleTmuxMenu'))
    elseif option == 'Run Python File' || option == 'Run Shell Script'
        call run#file()
    endif
endfunction

function! s:HandleFileMenu(id, choice)
    if a:choice == -1 | return | endif
    let option = s:file_menu[a:choice - 1]
    if option == 'Run File'
        call run#file()
    elseif option == 'Run File with Args'
        call inputsave()
        let args = input('Enter arguments: ')
        call inputrestore()
        call run#file_with_args(args)
    elseif option == 'Make'
        Make
    elseif option == 'Generate CTags'
        Ctags
    endif
endfunction

function! s:HandleCodeMenu(id, choice)
    if a:choice == -1 | return | endif
    let option = s:code_menu[a:choice - 1]
    if option == 'Goto Definition'
        execute "normal! \<C-]>"
    elseif option == 'Find References'
        execute "normal! g\<C-]>"
    endif
endfunction

function! s:HandleTextMenu(id, choice)
    if a:choice == -1 | return | endif
    let option = s:text_menu[a:choice - 1]
    if option == 'Remove Trailing Whitespace'
        call format#remove_trailing_whitespace()
    elseif option == 'Create Hyperlink'
        call utils#hyperlink()
    elseif option == 'Replace Selection'
        call utils#replace_selection()
    endif
endfunction

function! s:HandleInfoMenu(id, choice)
    if a:choice == -1 | return | endif
    let option = s:info_menu[a:choice - 1]
    if option == 'Highlight Group'
        call info#highlight_group()
    elseif option == 'Syntax Group'
        call info#syntax_group()
    elseif option == 'Get Vim Info'
        call info#get()
    endif
endfunction

function! s:HandleRunMenu(id, choice)
    if a:choice == -1 | return | endif
    let option = s:run_menu[a:choice - 1]
    if option == 'Run Visual Selection as Shell Command'
        call run#visual_selection_as_shell_cmd()
    elseif option == 'Run Visual Selection as VimScript'
        call run#visual_selection_as_vimscript()
    endif
endfunction

function! s:HandleFormatMenu(id, choice)
    if a:choice == -1 | return | endif
    let option = s:format_menu[a:choice - 1]
    if option == 'Format Buffer'
        Fmt
    elseif option == 'Format Selection'
        '<,'>call format#buffer()
    endif
endfunction

function! s:HandleTmuxMenu(id, choice)
    if a:choice == -1 | return | endif
    let option = s:tmux_menu[a:choice - 1]
    if option == 'Send to Tmux'
        call inputsave()
        let tmux_command = input('Enter command to send to Tmux: ')
        call inputrestore()
        call s:vimuxSendKeys(tmux_command)
    elseif option == 'Open Runner'
        call s:openRunner()
    elseif option == 'Close Runner'
        call s:closeRunner()
    elseif option == 'Navigate Left'
        TmuxNavigateLeft
    elseif option == 'Navigate Down'
        TmuxNavigateDown
    elseif option == 'Navigate Up'
        TmuxNavigateUp
    elseif option == 'Navigate Right'
        TmuxNavigateRight
    elseif option == 'Navigate Previous'
        TmuxNavigatePrevious
    endif
endfunction

" Key mapping to show the menu
nnoremap <localleader>, :call <SID>ShowMainMenu()<CR>
vnoremap <localleader>, :call <SID>ShowMainMenu()<CR>

let &cpo = s:save_cpo
unlet s:save_cpo
