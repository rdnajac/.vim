setlocal nonumber

nnoremap <buffer> <Left> <Plug>(dirvish_up)
nnoremap <buffer> <Right> <Cmd>call dirvish#open("edit", 0)<CR>
nnoremap <buffer> h <Plug>(dirvish_up)
nnoremap <buffer> l <Cmd>call dirvish#open("edit", 0)<CR>
nnoremap <buffer> t o<Esc>:r !find '<C-R>=substitute(getline(line(".")-1),"\\n","","g")<CR>' -maxdepth 1 -print0 \| xargs -0 ls -Fd<CR>:silent! keeppatterns %s/\/\//\//g<CR>:silent! keeppatterns %s/[^a-zA-Z0-9\/]$//g<CR>:silent! keeppatterns g/^$/d _<CR>"_dd\| :lua require('nvim.icons.fs').render()<CR>

if !has('nvim')
  finish
endif

nnoremap <buffer> o <Cmd>lua vim.ui.input( { prompt = 'new file: ' }, function(input) vim.cmd.edit(vim.fs.joinpath(vim.b.dirvish._dir, input)) end)
nnoremap <buffer> D <Cmd>lua vim.lsp.buf.code_action({filter=function(action) return action.command and action.command.command == 'delete' end, apply=true})<CR>
nnoremap <buffer> C <Cmd>lua vim.lsp.buf.code_action({filter=function(action) return action.command and action.command.command == 'rename' end, apply=true})<CR>

lua << EOF
-- XXX: `dirvish#add_icon_fn()` doesn't support highlighting
require('nvim.util.icons.fs').render()
-- require('nvim.util.git.extmarks').setup()
vim.lsp.buf_attach_client(0, nv.lsp.dirvish.client_id)
-- BUG: https://github.com/justinmk/vim-dirvish/issues/257
vim.opt_local.listchars = vim.opt.listchars:get()
vim.opt_local.listchars:remove('precedes')

-- local dirvish_line = {
  -- a = [[%{%v:lua.nv.icons.directory(b:dirvish._dir)..' '..fnamemodify(b:dirvish._dir, ':~')%}]],
  -- b = [[%{%v:lua.nv.lsp.dirvish.status()%}]],
  -- c = [[ %{join(map if opts.ft == '(argv(), "fnamemodify(v:val, ':t')"), ', ')} ]],
-- }
EOF

" let g:dirvish_mode = ':sort ,^.*[\/],'
" lua vim.g.dirvish_mode = [[:sort ,^.*[\/],]]
" if dirvish:
" command! -nargs=? -complete=dir Explore Dirvish <args>
" command! -nargs=? -complete=dir Sexplore belowright split | silent Dirvish <args>
" command! -nargs=? -complete=dir Vexplore leftabove vsplit | silent Dirvish <args>
