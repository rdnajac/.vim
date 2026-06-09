local M = {}

---@module "blink.cmp"

M.fuzzy = {
  sorts = {
    function(a, b)
      if a.source_id ~= 'registers' or b.source_id ~= 'registers' then
        return
      end
      if a.sortText == nil or b.sortText == nil or a.sortText == b.sortText then
        return
      end
      return a.sortText < b.sortText
    end,
    'score',
    'sort_text',
  },
}

M.keymap = {
  preset = 'enter',
  -- preset = 'none',
  -- overrides default `:h i_CTRL-R`
  -- ['<C-R>'] = { function(cmp) return cmp.show({ providers = { 'registers' } }) end },
  ['<C-x><C-r>'] = { function(cmp) return cmp.show({ providers = { 'registers' } }) end },
  ['<C-x><C-x>'] = { function(cmp) return cmp.show({ providers = { 'snippets' } }) end },
  ['<A-1>'] = { function(cmp) cmp.accept({ index = 1 }) end },
}
for i = 1, 9 do
  M.keymap['<A-' .. i .. '>'] = { function(cmp) cmp.accept({ index = i }) end }
end

M.sources = {
  providers = {
    lsp = {
      --   score_offset = -1,
      --   transform_items = function(_, items)
      --     return vim
      --       .iter(items)
      --       :filter(function(item)
      --         return not vim.tbl_contains({
      --           -- 'Snippet',
      --           -- 'Keyword'
      --         }, vim.lsp.protocol.CompletionItemKind[item.kind])
      --       end)
      --       :totable()
      --   end,
    },
    path = {
      score_offset = 100,
      opts = {
        get_cwd = function(_) return vim.fn.getcwd() end,
        show_hidden_files_by_default = true,
      },
    },
    snippets = {
      -- score_offset = 99,
      opts = { friendly_snippets = false },
      -- https://cmp.saghen.dev/recipes.html#hide-snippets-after-trigger-character
      -- TODO: no snippets in middle of word
      should_show_items = function(ctx)
        if require('nvim.util').is_comment() then
          return false
        else
          return ctx.trigger.initial_kind ~= 'trigger_character'
        end
      end,
    },
    -- define custom providers below
    -- ['dadbod'] = {
    --   name = 'dadbod',
    --   module = 'vim_dadbod_completion.blink',
    -- },
    ['env'] = {
      name = 'env',
      module = 'blink.env',
    },
    ['lazydev'] = {
      name = 'LazyDev',
      module = 'blink.lazy',
      score_offset = 100,
    },
    ['registers'] = {
      name = 'registers',
      module = 'blink.registers',
    },
  },
}

-- local active_sources = function()
--   return vim.iter(require('blink.cmp.sources.lib').get_enabled_providers(
--         ({ c = 'cmdline', t = 'term' })[vim.fn.mode():sub(1, 1)] or 'default'
--       )):totable()
-- end

return M
