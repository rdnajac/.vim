vim.cmd([[
setlocal nonumber
  " see `:ls`, `:bnext`/`:bprevious`, and `:h alternate-file`
setlocal nobuflisted
nnoremap <buffer> t o<Esc>:r !find '<C-R>=substitute(getline(line(".")-1),"\\n","","g")<CR>' -maxdepth 1 -print0 \| xargs -0 ls -Fd<CR>:silent! keeppatterns %s/\/\//\//g<CR>:silent! keeppatterns %s/[^a-zA-Z0-9\/]$//g<CR>:silent! keeppatterns g/^$/d _<CR>"_dd<CR>
nnoremap <buffer> D <Cmd>lua vim.lsp.buf.code_action({filter=function(action) return action.command and action.command.command == 'delete' end, apply=true})<CR>
nnoremap <buffer> r <Cmd>lua vim.lsp.buf.code_action({filter=function(action) return action.command and action.command.command == 'rename' end, apply=true})<CR>
]])

-- see `:h dir`
local dir = vim.api.nvim_buf_get_name(0)
-- vim.schedule(nv.fs.thumbnails.render)
vim.lsp.start({ cmd = nv.fs._lsp.cmd, name = 'my-server', root_dir = vim.env.HOME }, { attach = true })

--- create normal mode buffer-local keymaps
--- @param lhs string|table
--- @param rhs string|function
--- @param opts table|nil
local nmap = function(lhs, rhs, opts)
  vim.keymap.set('n', lhs, rhs, vim.tbl_extend('force', { buffer = 0 }, opts or {}))
end

nmap({ 'h', '<Left>' }, '<Plug>(nvim-dir-up)')
nmap({ 'l', '<Right>' }, '<Plug>(nvim-dir-open)')
nmap('o', function()
  vim.ui.input({ prompt = 'new file: ' }, function(input)
    vim.cmd.edit(vim.fs.joinpath(vim.fn.expand('%'), input))
  end)
end)

nmap('<C-e>', function()
  Snacks.explorer({ cwd = vim.api.nvim_buf_get_name(0) })
end)

-- nmap('D', function() vim.lsp.buf.code_action({ filter = function(action) return action.command and action.command.command == 'delete' end, apply = true }) end)
-- nmap('r', function() vim.lsp.buf.code_action({ filter = function(action) return action.command and action.command.command == 'rename' end, apply = true }) end)
--
-- local function action(action)
--   return action.command and action.command.command == action
-- end
-- nmap('D', function() vim.lsp.buf.code_action({ filter = action('delete'), apply = true }) end)
-- nmap('r', function() vim.lsp.buf.code_action({ filter = action('rename'), apply = true }) end)
