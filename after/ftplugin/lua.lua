-- TODO: only disable highlighting inside of `vim.cmd([[...]])`
-- Snacks.util.set_hl({ LspReferenceText = { link = 'NONE' } })

-- -- TODO: use `--search-parent-directories` or detect root lua
-- vim.bo.formatprg = 'stylua --stdin-filepath='
--     .. vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':p')
--     .. ' -f '
--     .. vim.fs.joinpath(vim.fn.stdpath('config'), 'stylua.toml')

-- Keep using legacy syntax for `vim-endwise`
vim.bo.syntax = 'ON'

vim.cmd([[
 setlocal nonumber signcolumn=yes:1
 setlocal foldtext=v:lua.nv.foldtext()
]])

local function nmap(lhs, rhs, desc)
  vim.keymap.set('n', lhs, rhs, { buffer = true, desc = desc })
end

nmap('crf', nv.coerce.form, 'local function foo() ↔ local foo = function()')
nmap('crf', nv.coerce.scope, 'local x ↔ M.x')
nmap('crM', nv.coerce.formscope, 'local function foo() → M.foo = function()')
nmap('crF', nv.coerce.scopeform, 'M.foo = function() → local function foo()')
--stylua: ignore end

vim.keymap.set('n', 'ym', nv.yankmod.name, { buffer = true, desc = 'yank lua module name' })
vim.keymap.set('n', 'yM', nv.yankmod.require, { buffer = true, desc = 'yank require(...) form' })
vim.keymap.set('n', 'yr', nv.yankmod.func, { buffer = true, desc = 'yank require + function' })
vim.keymap.set('n', 'yR', nv.yankmod.print, { buffer = true, desc = 'print require + function' })
vim.keymap.set('n', 'y<CR>', nv.yankmod.print, { buffer = true, desc = 'print require + function' })

_G.nv.foldtext = function()
  local foldstart = vim.v.foldstart
  local start_line = vim.fn.getline(foldstart)
  local next_line = vim.fn.getline(foldstart + 1)

  if start_line:match('{%s*$') then
    -- fold start ends with `{` (possibly followed by spaces)
    return start_line .. next_line
  end

  if vim.fn.indent(foldstart + 1) > vim.fn.indent(foldstart) then
    return next_line
  end

  return start_line
end

-- TODO:
vim.b.minisurround_config = {
  custom_surroundings = {
    L = {
      input = { '%[().-()%]%(.-%)' },
      output = function()
        local link = require('mini.surround').user_input('Link: ')
        return { left = '[', right = '](' .. link .. ')' }
      end,
    },
  },
}
