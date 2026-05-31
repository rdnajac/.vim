local lazyspec = require('symbiote.lazy')
Plug(lazyspec)

vim.lsp.config('copilot', {
  root_dir = vim.fn.expand('~/GitHub'),
})

vim.lsp.enable('copilot')

vim.keymap.set(
  { 'n' },
  '<Plug>(symbiote-tab)',
  require('symbiote.tab'),
  { expr = true, silent = true }
)

local inline_completion = vim.lsp.inline_completion
inline_completion.enable()

vim.keymap.set('i', '<C-J>', function()
  if not inline_completion.get() then
    return '<C-J>'
  end
end, { expr = true, desc = 'Accept the current inline completion' })

-- create Snacks.toggles
if not Snacks then
  return
end

Snacks.toggle({
  name = 'Inline Completion',
  get = function() return inline_completion.is_enabled() end,
  set = function(state) inline_completion.enable(state) end,
}):map('<leader>ai')

local nes = require('sidekick.nes')
-- nes.enable(false)
Snacks.toggle({
  name = 'Sidekick NES',
  get = function() return nes.enabled end,
  set = function(state) nes.enable(state) end,
}):map('<leader>an')
