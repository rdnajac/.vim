---@type table<string, blink.cmp.SourceProviderConfig>
local M = {}

M.buffer = {
  -- opts = {
  --   get_bufnrs = function()
  --     return vim.tbl_filter(function(bufnr)
  --       return vim.bo[bufnr].buftype == ''
  --     end, vim.api.nvim_list_bufs())
  --   end,
  -- },
}

M.lsp = {
  score_offset = -1,
  transform_items = function(_, items)
    local kind = require('blink.cmp.types').CompletionItemKind
    local exclude = vim.tbl_map(function(k)
      return kind[k]
    end, {
      'Snippet',
      -- 'Keyword'
    })
    return vim.tbl_filter(function(item)
      return not vim.tbl_contains(exclude, item.kind)
    end, items)
  end,
}

M.path = {
  score_offset = 100,
  opts = {
    get_cwd = function(_)
      return vim.fn.getcwd()
    end,
    show_hidden_files_by_default = true,
  },
}

M.snippets = {
  score_offset = 99,
  opts = { friendly_snippets = false },
  -- https://cmp.saghen.dev/recipes.html#hide-snippets-after-trigger-character
  should_show_items = function(ctx)
    return ctx.trigger.initial_kind ~= 'trigger_character'
  end,
}

return M
