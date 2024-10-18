" vim/plugin/popup.vim
scriptencoding utf-8

let g:popup_options = {
      \ 'hidden': v:true,
      \ 'border': [1, 1, 1, 1],
      \ 'borderhighlight': ['String'],
      \ 'borderchars': ['─', '│', '─', '│', '╭', '╮', '╯', '╰'],
      \ 'line': (&lines - 2),
      \ 'close': 'click',
      \ 'title': '',
      \ }

function! g:Popup(text, ...)
    let popup_opts = copy(g:popup_options)
    
    if a:0 > 0
        let title = a:1
        if title !=# ''
            let popup_opts['title'] = title
        endif
    endif

    let popid = popup_create(a:text, popup_opts)
    call popup_show(popid)
endfunction
