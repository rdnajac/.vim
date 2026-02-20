--- completion

-- vim.o.complete        = '.,w,b,kspell'                  -- Use less sources
-- vim.o.completeopt     = 'menuone,noselect,fuzzy,nosort' -- Use custom behavior
-- vim.o.completetimeout = 100                             -- Limit sources delay

-- not needed with automatic loading
-- vim.lsp.enable('copilot')

-- TODO: if not using copilot.vim
vim.lsp.inline_completion.enable()

-- vim.keymap.set('i', '<Tab>', function()
--   if not vim.lsp.inline_completion.get() then
--     return '<Tab>'
--   end
-- end, { expr = true, desc = 'Accept the current inline completion' })

-- NOTE: In GUI and supporting terminals, `<C-i>` can be mapped separately from `<Tab>`
-- ...except in tmux: `https://github.com/tmux/tmux/issues/2705`
-- vim.keymap.set('n', '<C-i>', '<Tab>', { desc = 'restore <C-i>' })

local toggle_inline_completion = Snacks.toggle.new({
  name = 'Inline Completion',
  get = function() return vim.lsp.inline_completion.is_enabled() end,
  set = function(state) vim.lsp.inline_completion.enable(state) end,
})
toggle_inline_completion:map('<leader>ai')

-- FIXME:
-- local aug = vim.api.nvim_create_augroup('HideInlineCompletion', {})
-- vim.api.nvim_create_autocmd('User', {
--   group = aug,
--   pattern = 'BlinkCmpMenuOpen',
--   callback = function() toggle_inline_completion:toggle() end,
-- })
-- vim.api.nvim_create_autocmd('User', {
--   group = aug,
--   pattern = 'BlinkCmpMenuClose',
--   callback = function() toggle_inline_completion:toggle() end,
-- })
