--- completion

-- vim.o.complete = '.,w,b,kspell'                     -- use fewer sources
-- vim.o.completeopt = 'menuone,noselect,fuzzy,nosort' -- set custom behavior
-- vim.o.completetimeout = 100                         -- limit sources delay

-- not needed with automatic loading
-- vim.lsp.enable('copilot')

-- vim.keymap.set('i', '<Tab>', function()
--   if not vim.lsp.inline_completion.get() then
--     return '<Tab>'
--   end
-- end, { expr = true, desc = 'Accept the current inline completion' })

-- NOTE: In GUI and supporting terminals, `<C-i>` can be mapped separately from `<Tab>`
-- ...except in tmux: `https://github.com/tmux/tmux/issues/2705`
-- vim.keymap.set('n', '<C-i>', '<Tab>', { desc = 'restore <C-i>' })

  -- })
