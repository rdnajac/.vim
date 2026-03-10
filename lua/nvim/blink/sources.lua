---@module "blink.cmp"
--- `https://cmp.saghen.dev/configuration/sources.html#community-sources`

local sources = {
  ---@type table<string, blink.cmp.SourceListPerFiletype>
  per_filetype = {},
  ---@type table<string, blink.cmp.SourceProviderConfig>
  providers = {
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
        if require('nvim.util').is_comment() then
          return false
        else
          return ctx.trigger.initial_kind ~= 'trigger_character'
        end
      end,
    },
    -- define custom default providers here
    env = {
      name = 'env',
      module = 'nvim.blink.sources.env',
    },
  },
}

sources.default = vim.tbl_keys(sources.providers)

sources.providers['lazydev'] = {
  name = 'LazyDev',
  module = 'nvim.blink.sources.lazy',
  score_offset = 100,
}
sources.per_filetype['lua'] = { inherit_defaults = true, 'lazydev' }

sources.providers['dadbod'] = {
  name = 'dadbod',
  module = 'vim_dadbod_completion.blink',
}
sources.per_filetype['sql'] = { inherit_defaults = false, 'dadbod' }

return sources
