-- `https://cmp.saghen.dev/`
local M = {
  {
    'Saghen/blink.cmp',
    -- event = 'InsertEnter',
    build = 'BlinkCmp build',
    ---@type blink.cmp.Config
    opts = {
      cmdline = { enabled = false },
      -- fuzzy = { implementation = 'lua' },
      keymap = {
        ['<Tab>'] = {
          function(cmp)
            if cmp.snippet_active() then
              return cmp.accept()
            else
              return cmp.select_and_accept()
            end
          end,
          'snippet_forward',
          function()
            if not package.loaded['sidekick'] then
              return false
            end
            return require('sidekick').nes_jump_or_apply()
          end,
          function()
            return vim.lsp.inline_completion.get()
          end,
          'fallback',
        },
      },
      signature = {
        enabled = true,
        window = { show_documentation = false },
      },
      completion = {
        accept = { auto_brackets = { enabled = true } },
        documentation = { auto_show = false },
        ghost_text = { enabled = false },
        -- keyword = {},
        trigger = {
          show_on_keyword = true,
          show_on_accept_on_trigger_character = true,
          show_on_x_blocked_trigger_characters = { '"', '(', '{', '[' },
        },
        list = { selection = { preselect = true, auto_insert = true } },
      },
    },
    after = function()
      -- NOTE: In GUI and supporting terminals, `<C-i>` can be mapped separately from `<Tab>`
      -- ...except in tmux: `https://github.com/tmux/tmux/issues/2705`
      -- vim.keymap.set('n', '<C-i>', '<Tab>', { desc = 'restore <C-i>' })
    end,
  },
}

local function to_icon(provider)
  return nv.icons.blink[provider] or ' '
end

-- Set the highlight priority to 20000 to beat the cursorline's default priority of 10000
---@param ctx blink.cmp.DrawItemContext
local component_highlight = function(ctx)
  return { { group = ctx.kind_hl, priority = 20000 } }
end

M[1].opts.completion.menu = {
  auto_show = true,
  ---@param ctx blink.cmp.Context
  ---@returns number the delay in milliseconds
  auto_show_delay_ms = function(ctx, _)
    if vim.tbl_contains({ '.', '/', "'", '@' }, ctx.trigger.initial_character) then
      return 0
    end
    return 420
  end,

  -- https://cmp.saghen.dev/recipes.html#avoid-multi-line-completion-ghost-text- border = border,
  ---@diagnostic disable-next-line: assign-type-mismatch
  direction_priority = function()
    local cmp = require('blink.cmp')
    local ctx = cmp.get_context()
    local item = cmp.get_selected_item()
    if ctx and item then
      local item_text = (item.textEdit and item.textEdit.newText) or item.insertText or item.label
      -- local is_multi_line = item_text:find('\n') ~= nil
      -- after showing the menu upwards, we want to maintain that direction
      -- until we re-open the menu, so store the context id in a global variable
      -- if is_multi_line or vim.g.blink_cmp_upwards_ctx_id == ctx.id then
      if item_text:find('\n') or vim.g.blink_cmp_upwards_ctx_id == ctx.id then
        vim.g.blink_cmp_upwards_ctx_id = ctx.id
        return { 'n', 's' }
      end
    end
    return { 's', 'n' }
  end,

  ---@type blink.cmp.Draw
  draw = {
    treesitter = { 'lsp' },
    ---@type blink.cmp.DrawColumnDefinition[]
    columns = {
      { 'source_id', 'kind_icon' },
      { 'label', 'label_description', gap = 1 },
    },
    ---@type table<string, blink.cmp.DrawComponent>
    components = {
      source_id = {
        ellipsis = false,
        text = function(ctx)
          return to_icon(ctx.source_name) .. ctx.icon_gap
        end,
        highlight = component_highlight,
      },
      kind_icon = {
        text = function(ctx)
          return nv.icons.kinds[ctx.kind] or ''
        end,
        highlight = component_highlight,
      },
    },
  },
}

---@type table<string, blink.cmp.SourceProviderConfig>
local default_providers = {
  buffer = {
    -- opts = {
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
  },
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
    -- https://cmp.saghen.dev/recipes.html#hide-snippets-after-trigger-character
    should_show_items = function(ctx)
      return ctx.trigger.initial_kind ~= 'trigger_character'
    end,
  },
}

M[1].opts.sources = {
  ---@return blink.cmp.SourceList[]
  default = function()
    return vim.tbl_filter(function(src)
      return nv.treesitter.is_comment() and src ~= 'snippets' or true
    end, vim.tbl_keys(default_providers))
  end,
  per_filetype = {
    lua = { inherit_defaults = true, 'lazydev' },
    -- sql = { 'dadbod' },
  },
  providers = vim.tbl_extend('force', {}, default_providers, {
    lazydev = {
      name = 'LazyDev',
      module = 'lazydev.integrations.blink',
      score_offset = 100,
    },
  }),
}

---@type table<string, blink.cmp.SourceProviderConfigPartial>
local extras = {
  ['bydlw98/blink-cmp-env'] = {
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
  },
}

for k, v in pairs(extras) do
  -- vim.list_extend(M, { k })
  table.insert(M, { k })
  M[1].opts.sources.providers = vim.tbl_extend('force', M[1].opts.sources.providers, v)
end

local providers = function(mode)
  mode = (mode or vim.api.nvim_get_mode().mode):sub(1, 1)
  local cmp_mode = ({ c = 'cmdline', t = 'terminal' })[mode] or 'default'
  return vim.tbl_keys(require('blink.cmp.sources.lib').get_enabled_providers(cmp_mode))
end

nv.blink = {
  status = {
    function()
      return vim.iter(providers()):map(to_icon):join(' ')
    end,
    cond = function()
      return package.loaded['blink.cmp'] and vim.fn.mode():sub(1, 1) == 'i'
    end,
  },
}

return M
