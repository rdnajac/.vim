if vim.g.loaded_endwise == 1 then
  vim.bo.syntax = 'ON' -- keep using legacy syntax
end
vim.wo.foldmethod = 'expr'
vim.wo.foldtext = [[v:lua.require'nvim.util'.foldtext()]]

local coerce = require('nvim.util.fn.coerce')
local yankmod = require('nvim.util.fn.yankmod')

-- stylua: ignore
-- TODO: make this a lsp action
local mappings = {
  { 'crf', coerce.form,          'local function foo() ↔ local foo = function()' },
  { 'crM', coerce.formscope,     'local function foo() → M.foo = function()' },
  { 'crF', coerce.scopeform,     'M.foo = function() → local function foo()' },
  { 'crS', coerce.scope,         'local x ↔ M.x' },
  { 'crv', '^d3wivim.g.<Esc>',   'CoeRce Vim global to `vim.g.%s =`' },
  { 'crV', '^df4wilet g:<Esc>', ' CoeRce `vim.g.%s` to `let g:%s =`' },
  { 'yr',  yankmod.require,      'yank require + function' },
  { 'yR',  yankmod.require_func, 'print require + function' },
}

for _, map in ipairs(mappings) do
  vim.keymap.set('n', map[1], map[2], { buffer = true, desc = map[3] })
end

vim.b.minisurround_config = {
  custom_surroundings = {
    U = { output = { left = 'function()\n', right = '\nend' } },
    u = { output = { left = 'function() ', right = ' end' } },
    i = { output = { left = '-- stylua: ignore start\n', right = '\n-- stylua: ignore end' } },
    S = { output = { left = 'vim.schedule(function()\n  ', right = '\nend)' } },
    s = { input = { '%[%[().-()%]%]' }, output = { left = '[[', right = ']]' } },
  },
}

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

if Snacks then
  vim.keymap.set({ 'n', 'x' }, '<M-CR>', Snacks.debug.run, { buffer = true })

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
end
