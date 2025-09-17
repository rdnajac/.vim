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

---@ module "blink-cmp"
---@ type blink.cmp.KeymapConfig
return {
  -- default if we had selected a preset
  ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
  -- ['<C-e>'] = { 'cancel', 'fallback' },
  -- ['<C-y>'] = { 'select_and_accept', 'fallback' },
  -- supertab
  ['<Tab>'] = {
    function(cmp)
      if cmp.snippet_active() then
        return cmp.accept()
      else
        return cmp.select_and_accept()
      end
    end,
    'snippet_forward',
    'fallback',
  },
  ['.'] = {
    function(cmp)
      if cmp.is_menu_visible() then
        ---@ type blink.cmp.CompletionItem?
        local sel = cmp.get_selected_item()
        if sel and sel.source_name == 'LazyDev' then
          cmp.select_and_accept()
          -- vim.defer_fn(function()
          cmp.show({ providers = { 'lazydev' } })
          -- end, 1)
          return
        end
        --- @type blink.cmp.Context
        -- local ctx = cmp.get_context()
        -- if vim.tbl_contains(ctx.providers, 'LazyDev') then
        --   return cmp
        -- end
      end
    end,
    'fallback',
  },
}
