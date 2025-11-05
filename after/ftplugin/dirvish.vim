lua require('nvim.icons.fs').render()

nnoremap <buffer> h <Plug>(dirvish_up)
nnoremap <buffer> <Left> <Plug>(dirvish_up)

nmap <buffer> l <CR>
nmap <buffer> <Right> <CR>

nnoremap <buffer> t o<Esc>:r !find '<C-R>=substitute(getline(line(".")-1),"\\n","","g")<CR>' -maxdepth 1 -print0 \| xargs -0 ls -Fd<CR>:silent! keeppatterns %s/\/\//\//g<CR>:silent! keeppatterns %s/[^a-zA-Z0-9\/]$//g<CR>:silent! keeppatterns g/^$/d _<CR>"_dd\| :lua require('nvim/util/fs').apply_icons()<CR>|redraw!

if !has('nvim')
  finish
endif

nmap <buffer> r <Cmd>lua Snacks.rename.rename_file({ from = vim.fn.expand('<cfile>'), on_rename = function() vim.cmd.Dirvish() end })<CR>
