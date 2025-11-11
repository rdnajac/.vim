vim.bo.syntax = 'ON' -- Keep using legacy syntax for `vim-endwise`
-- vim.wo.foldmethod = 'expr' -- foldexpression already set by ftplugin

local function nmap(lhs, rhs, desc)
  vim.keymap.set('n', lhs, rhs, { buffer = true, desc = desc })
end

nmap('crf', nv.fn.coerce.form, 'local function foo() ↔ local foo = function()')
nmap('crM', nv.fn.coerce.formscope, 'local function foo() → M.foo = function()')
nmap('crF', nv.fn.coerce.scopeform, 'M.foo = function() → local function foo()')
-- FIXME: conflicts with abolish
-- nmap('crm',   nv.fn.coerce.scope,     'local x ↔ M.x')

nmap('ym',    nv.fn.yankmod.name, 'yank lua module name')
nmap('yM',    nv.fn.yankmod.require, 'yank require(...) form')
nmap('yr',    nv.fn.yankmod.func, 'yank require + function')
nmap('yR',    nv.fn.yankmod.print, 'print require + function')
nmap('y<CR>', nv.fn.yankmod.print, 'print require + function')

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
