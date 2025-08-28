---@module "blink.cmp"
---@type blink.cmp.SourceConfig
local M = {}

local kind = vim.lsp.protocol.SymbolKind
-- local kind = require('blink.cmp.types').CompletionItemKind

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
    -- transform_items = function(_, items) return vim.tbl_filter(function(item) return is_in_comment() end, items) end,
  },
  lsp = {
    score_offset = 1,
    transform_items = function(_, items)
      return vim.tbl_filter(function(item)
        -- FILTER OUT KEYWORDS AND SNIPPETS FROM LSP
        return item.kind ~= kind.Keyword and item.kind ~= kind.Snippet
      end, items)
    end,
  },
}

local ft_sources = {
  lua = { 'lazydev' },
  -- r = { 'cmp_r' },
  -- rmd = { 'cmp_r' },
  -- quarto = { 'cmp_r' },
  sh = { 'env' },
}

---@return blink.cmp.SourceList[]
M.default = function()
  -- FIXME: sometimes we still get snippets in comments
  if require('nvim.treesitter').in_comment_node() then
    return { 'buffer' }
  end
  return vim.list_extend(vim.tbl_keys(default_providers), ft_sources[vim.bo.filetype] or {})
end

M.providers = {
  lazydev = {
    name = 'LazyDev',
    module = 'lazydev.integrations.blink',
    score_offset = 100,
  },
  -- copilot = {
  --   name = 'copilot',
  --   module = 'blink-copilot',
  --   -- score_offset = 10,
  --   async = true,
  --   opts = { max_completions = 2 },
  -- },
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
  -- tmux = {
  --   name = 'tmux',
  --   module = 'blink-cmp-tmux',
  --   score_offset = -1,
  --   opts = {
  --     all_panes = true,
  --     capture_history = true,
  --   },
  -- },
}

return M
