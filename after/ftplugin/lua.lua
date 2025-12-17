vim.bo.syntax = 'ON' -- Keep using legacy syntax for `vim-endwise`
-- vim.wo.foldmethod = 'expr' -- foldexpression already set by ftplugin

local fn = require('nvim.util.fn')
-- stylua: ignore
local mappings = {
  { 'crf', fn.coerce.form,          'local function foo() ↔ local foo = function()' },
  { 'crM', fn.coerce.formscope,     'local function foo() → M.foo = function()' },
  { 'crF', fn.coerce.scopeform,     'M.foo = function() → local function foo()' },
  { 'crS', fn.coerce.scope,         'local x ↔ M.x' },
  { 'yr',  fn.yankmod.require,      'yank require + function' },
  { 'yR',  fn.yankmod.require_func, 'print require + function' },
}

for _, map in ipairs(mappings) do
  local lhs, rhs, desc = unpack(map)
  vim.keymap.set('n', lhs, rhs, { buffer = true, desc = desc })
end

if MiniSplitjoin then
  local gen_hook = MiniSplitjoin.gen_hook
  local curly = { brackets = { '%b{}' } }
  local add_comma_curly = gen_hook.add_trailing_separator(curly)
  local del_comma_curly = gen_hook.del_trailing_separator(curly)
  local pad_curly = gen_hook.pad_brackets(curly)
  vim.b.minisplitjoin_config = {
    split = { hooks_post = { add_comma_curly } },
    join = { hooks_post = { del_comma_curly, pad_curly } },
  }
end

local aug = vim.api.nvim_create_augroup('lua', {})

-- TODO: only disable highlighting inside of `vim.cmd([[...]])`
vim.api.nvim_create_autocmd({ 'InsertEnter' }, {
  group = aug,
  callback = function()
    vim.b.old_hl = Snacks.util.color('LspReferenceText', 'bg')
    Snacks.util.set_hl({ LspReferenceText = { link = 'NONE' } })
  end,
})
vim.api.nvim_create_autocmd({ 'InsertLeave' }, {
  group = aug,
  callback = function()
    if vim.b.old_hl then
      Snacks.util.set_hl({ LspReferenceText = { bg = vim.b.old_hl } })
      vim.b.old_hl = nil
    end
  end,
})
