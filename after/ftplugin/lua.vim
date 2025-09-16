setlocal expandtab
setlocal formatoptions-=ro

" let &l:formatprg = 'stylua --search-parent-directories --stdin-filepath=% -'
let &l:formatprg = 'stylua -f ~/.vim/stylua.toml --stdin-filepath=% -'

inoremap <buffer> \si --<SPACE>stylua:<SPACE>ignore
inoremap <buffer> \ss --<SPACE>stylua:<SPACE>ignore<SPACE>start
inoremap <buffer> \se --<SPACE>stylua:<SPACE>ignore<SPACE>end

inoremap <buffer> \fu function() end,<Esc>gEa<Space>
iabbrev <buffer> fu function()

inoremap <buffer> `` vim.cmd([[]])<Left><Left><Left><C-g>u<CR><CR><esc>hi<Space><Space>

" NOTE: don't need vim-apathy for lua anymore:
" from `$VIMRUNTIME/runtime/ftplugin/lua.lua`
" includeexpr=v:lua.require'vim._ftplugin.lua'.includeexpr(v:fname)
" include=\<\%(\%(do\|load\)file\|require\)\s*(
" from ~/.local/share/nvim/share/nvim/runtime/ftplugin/lua.vim line 39
