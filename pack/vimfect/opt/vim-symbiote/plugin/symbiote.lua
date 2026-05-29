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

-- create Snacks.toggles
if not Snacks then
  return
end

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
