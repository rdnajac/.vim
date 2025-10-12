local M = {}

---@type table<string, blink.cmp.SourceProviderConfig>
local default_providers = {
  path = {
    score_offset = 100,
    opts = {
      get_cwd = function(_)
        return vim.fn.getcwd()
      end,
      show_hidden_files_by_default = true,
    },
  },
  snippets = {
    score_offset = 99,
    opts = { friendly_snippets = false },
    -- HIDE SNIPPETS AFTER TRIGGER CHARACTER ~
    should_show_items = function(ctx)
      return ctx.trigger.initial_kind ~= 'trigger_character'
    end,
  },
  -- Don't use LSP for:
  -- lua: just use lazydev
  -- r, rmd, quarto: use cmp_r
  lsp = {
    score_offset = -1,
    ---@ param ctx blink.cmp.Context
    ---@ param items blink.cmp.CompletionItem[]
    transform_items = function(ctx, items)
      local kind = require('blink.cmp.types').CompletionItemKind
      local exclude = vim.tbl_map(function(name)
        return kind[name]
      end, { 'Keyword', 'Snippet' })

      local ret = vim.tbl_filter(function(item)
        return not vim.tbl_contains(exclude, item.kind)
      end, items)
      --   local lazydev_items = vim.tbl_filter(function(item)
      --     return item.source_id == 'lazydev'
      --   end, items)
      --   if #lazydev_items == 0 then
      --     return items
      --   end
      --   local lazy_labels = {}
      --   for _, item in ipairs(lazydev_items) do
      --     lazy_labels[item.label] = true
      --   end
      --   return vim.tbl_filter(function(item)
      --     return not (item.source ~= 'lazydev' and lazy_labels[item.label])
      --   end, items)

      return ret
    end,
  },
}

local ft_sources = {
  lua = { 'lazydev' },
  r = { 'cmp_r' },
  rmd = { 'cmp_r' },
  quarto = { 'cmp_r' },
  sh = { 'env', 'lsp' },
  vim = { 'env', 'lsp' },
}

---@return blink.cmp.SourceList[]
M.default = function()
  if nv.treesitter.is_comment() then
    return { 'buffer' }
  end
  local defaults = vim.tbl_keys(default_providers)
  return vim.list_extend(defaults, ft_sources[vim.bo.filetype] or {})
end

M.providers = vim.tbl_extend('force', {}, default_providers, {
  lazydev = {
    name = 'LazyDev',
    module = 'lazydev.integrations.blink',
    score_offset = 100,
  },
  env = {
    name = 'env',
    module = 'blink-cmp-env',
    score_offset = -5,
    opts = {
      item_kind = function()
        return require('blink.cmp.types').CompletionItemKind.Variable
      end,
      show_braces = false,
      show_documentation_window = true,
    },
  },
  cmp_r = {
    name = 'cmp_r',
    module = 'blink.compat.source',
  },
})

return M
