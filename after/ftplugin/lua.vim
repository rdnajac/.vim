" let &l:formatprg = 'stylua --search-parent-directories --stdin-filepath=% -'
let &l:formatprg = 'stylua -f ~/.vim/stylua.toml --stdin-filepath=% -'

iabbrev <buffer> fu function()
inoremap <buffer> \fu function() end,<Esc>gEa<Space>
inoremap <buffer> \ig --<SPACE>stylua:<SPACE>ignore
inoremap <buffer> `` vim.cmd([[]])<Left><Left><Left><C-g>u<CR><CR><esc>hi<Space><Space>

inoremap <buffer> req<Tab> require(')<Left><Left>'

" NOTE: don't need `tpope/vim-apathy` for lua anymore:
" from `$VIMRUNTIME/runtime/ftplugin/lua.lua`
" includeexpr=v:lua.require'vim._ftplugin.lua'.includeexpr(v:fname)
" include=\<\%(\%(do\|load\)file\|require\)\s*(
" from ~/.local/share/nvim/share/nvim/runtime/ftplugin/lua.vim line 39

" custom surround using `tpope/vim-surround`
" use ascii value (i = 105)
" NOTE: must use double quotes
let b:surround_85 = "function() \r end"
let b:surround_117 = "function()\n \r \nend"
let b:surround_105 = "-- stylua: ignore start\n \r \n--stylua: ignore end"
let b:surround_115 = "vim.schedule(function()\n \r \nend)"
