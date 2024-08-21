" Experimental configurations for plugins
" REMEMBER: caps lock is control
" caps lock maps to control
" f and j keys have raised nibs
" CTRL + f is the tmux prefix
" CTRL + <Space> does UltiSnips expand/jump
" CTRL + j does CoPilot completion
" Use default YCM completion triggers

imap <silent><script><expr> <c-j> copilot#Accept("\<CR>")
let g:copilot_no_tab_map = v:true

" UltiSnips says I need this
" inoremap <c-x><c-k> <c-x><c-k>
" or is that a bad idea?

let g:UltiSnipsExpandTrigger="<c-space>"
" let g:UltiSnipsJumpForwardTrigger="<c-b>"
" let g:UltiSnipsJumpBackwardTrigger="<c-z>"
" let g:UltiSnipsListSnippets=<c-tab>
let g:UltiSnipsExpandOrJumpTrigger = "<c-space>"
" let g:UltiSnipsJumpOrExpandTrigger =

