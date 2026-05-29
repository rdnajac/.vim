vim.lsp.config('copilot', { root_dir = vim.fn.expand('~/GitHub') })
vim.lsp.enable('copilot')

Plug({
  {
    'folke/sidekick.nvim',
    opts = {},
  },
  { 'Saghen/blink.lib' },
  {
    'Saghen/blink.cmp',
    build = function() require('blink.cmp').build():wait(6e4) end,
    opts = require('blink.opts'),
  },
})

-- map <Tab> to accept completions
vim.keymap.set('n', '<Tab>', function()
  if vim.fn.pumvisible() ~= 0 then
    return '<C-y>'
  end
  if package.loaded['blink.cmp'] and require('blink.cmp').select_and_accept() then
    return
  end
  -- if there is a next edit, jump to it, otherwise apply it if any
  if package.loaded['sidekick'] and require('sidekick').nes_jump_or_apply() then
    return -- jumped or applied
  end
  if vim.lsp.inline_completion.get() then
    return
  end
  return '<Tab>' -- fallback
end, { expr = true, silent = true })

-- create Snacks.toggles
local inline_completion = vim.lsp.inline_completion
Snacks.toggle({
  name = 'Inline Completion',
  get = function() return inline_completion.is_enabled() end,
  set = function(state) inline_completion.enable(state) end,
}):map('<leader>ai')
-- inline_completion.enable()

local nes = require('sidekick.nes')
Snacks.toggle({
  name = 'Sidekick NES',
  get = function() return nes.enabled end,
  set = function(state) nes.enable(state) end,
}):map('<leader>an')
-- nes.enable()
