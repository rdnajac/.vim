-- vim.keymap.set('n', 'zS', vim.show_pos)
vim.keymap.set('n', '<leader>ui', vim.show_pos)

-- no hlsearch on <Esc>
-- vimscript: nnoremap <expr> <Esc> ':nohlsearch\<CR><Esc>'
-- vim.keymap.set({ 'i', 'n', 's' }, '<Esc>', function()
--   vim.cmd.nohlsearch()
--   return '<Esc>'
-- end, { expr = true, desc = 'Escape and Clear hlsearch' })

Snacks.util.on_key('<Esc>', vim.cmd.nohlsearch)

-- vim.keymap.set('i', '<Tab>', function()
--   local cmp = require('blink.cmp')
--
--   if vim.bo.filetype == 'lua' and vim.fn.getline('.'):match('require') then
--     cmp.show({ providers = { 'LazyDev' } })
--     return ''
--   end
--
--   local item = cmp.get_selected_item()
--   local type = require('blink.cmp.types').CompletionItemKind
--
--   if not vim.lsp.inline_completion.get() then
--     if cmp.is_visible() and item then
--       cmp.accept()
--       -- keep accepting path completions
--       if item.kind == type.Path then
--         vim.defer_fn(function()
--           cmp.show({ providers = { 'path' } })
--         end, 1)
--       end
--       return ''
--     end
--     return '<Tab>'
--   end
-- end, { expr = true })
