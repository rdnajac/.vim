" plugin/cd.vim - change directory
nnoremap cdc <Cmd>call bin#cd#smart()<CR>
nnoremap cdb <Cmd>cd %:p:h<BAR>pwd<CR>
nnoremap cdp <Cmd>cd %:p:h:h<BAR>pwd<CR>
nnoremap cdr :cd <C-R>=git#root()<CR><Bar>pwd<CR>
