---@module "blink.cmp"
---@type table<string, blink.cmp.SourceProviderConfig>
local providers = {
  buffer = {
    --   get_bufnrs = function()
    --     return vim.tbl_filter(function(bufnr)
    --       return vim.bo[bufnr].buftype == ''
    --     end, vim.api.nvim_list_bufs())
    --   end,
    -- },
  },
  lsp = {
    score_offset = -1,
    transform_items = function(_, items)
      local kind = require('blink.cmp.types').CompletionItemKind
      local exclude = vim.tbl_map(function(k) return kind[k] end, {
        'Snippet',
        -- 'Keyword'
      })
      return vim.tbl_filter(
        function(item) return not vim.tbl_contains(exclude, item.kind) end,
        items
      )
    end,
  },
  path = {
    score_offset = 100,
    opts = {
      get_cwd = function(_) return vim.fn.getcwd() end,
      show_hidden_files_by_default = true,
    },
  },
  snippets = {
    score_offset = 99,
    opts = { friendly_snippets = false },
    -- https://cmp.saghen.dev/recipes.html#hide-snippets-after-trigger-character
    -- FIXME: last line of a comment isn't a ts comment
    -- TODO: no snippets in middle of word
    should_show_items = function(ctx)
      if nv.is_comment() then
        return false
      else
        return ctx.trigger.initial_kind ~= 'trigger_character'
      end
    end,
  },
}
