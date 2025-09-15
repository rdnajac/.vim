-- local map = require('which-key').add
-- TODO: combine with which-key spec
vim.keymap.set({ 'i', 'n', 's' }, '<Esc>', function()
  vim.cmd.nohlsearch()
  return '<Esc>'
end, { expr = true, desc = 'Escape and Clear hlsearch' })
-- nnoremap <expr> <Esc> ":nohlsearch\<CR><Esc>"

-- FIXME:
-- local munchies_toggle = require('nvim.snacks.toggle')
--
-- munchies_toggle
--   .translucency()
--   :map('<leader>ub', { desc = 'Toggle Translucent Background' })
-- munchies_toggle.virtual_text():map('<leader>uv', { desc = 'Toggle Virtual Text' })
-- munchies_toggle.color_column():map('<leader>u\\', { desc = 'Toggle Color Column' })
-- munchies_toggle.winborder():map('<leader>uW', { desc = 'Toggle Window Border' })
-- munchies_toggle.laststatus():map('<leader>ul', { desc = 'Toggle Laststatus' })

-- Supertab
vim.keymap.set('i', '<Tab>', function()
  local cmp = require('blink.cmp')
  local item = cmp.get_selected_item()
  local type = require('blink.cmp.types').CompletionItemKind

  -- TODO: what about snippet expansion?
  -- TODO: how to hide copilot completion?
  if not vim.lsp.inline_completion.get() then
    if cmp.is_visible() and item then
      cmp.accept()
      -- keep accepting path completions
      if item.kind == type.Path then
        vim.defer_fn(function()
          cmp.show({ providers = { 'path' } })
        end, 1)
      end
      return ''
    end
  end
  return '<Tab>'
end, { expr = true })
