let g:dirvish_mode = ':sort ,^.*[\/],'
" BUG: workaround for https://github.com/justinmk/vim-dirvish/issues/257
" let &l:listchars = &listchars
" setlocal listchars-=precedes
lua vim.opt_local.listchars = vim.opt.listchars:get()
lua vim.opt_local.listchars:remove('precedes')

nnoremap <buffer> h <Plug>(dirvish_up)
nnoremap <buffer> <Left> <Plug>(dirvish_up)

nmap <buffer> l <CR>
nmap <buffer> <Right> <CR>

nnoremap <buffer> t o<Esc>:r !find '<C-R>=substitute(getline(line(".")-1),"\\n","","g")<CR>' -maxdepth 1 -print0 \| xargs -0 ls -Fd<CR>:silent! keeppatterns %s/\/\//\//g<CR>:silent! keeppatterns %s/[^a-zA-Z0-9\/]$//g<CR>:silent! keeppatterns g/^$/d _<CR>"_dd\| :lua require('nvim.icons.fs').render()<CR>|redraw!

" BUG: dirvish doesn't suppor highlighting icons out of the box yet
lua require('nvim.icons.fs').render()
lua nv.fn.defer_redraw(50)
" lua require('nvim.lsp._dirvish')
" " Create a Vimscript wrapper function that calls the Lua module
" function! DirvishIcons(path) abort
"   let l:entry = luaeval('require("nvim.icons.fs").get(_A)', a:path)
"   return [l:entry.icon, l:entry.hl]
" endfunction
"
" " Register the function with dirvish
" let g:dirvish_icon_id = dirvish#add_icon_fn(funcref('DirvishIcons'))
