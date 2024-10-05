vnoremap <leader>r :<C-u>call utils#replaceSelection()<CR>
" double space over word to find and replace
" the angle brackets are word boundaries
nnoremap <Space><Space> :%s/\<<C-r>=expand("<cword>")<CR>\>/
vnoremap <Space><Space> y:%s/\<<C-r>=escape(@",'/\')<CR>\>/
