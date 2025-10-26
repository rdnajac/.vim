-- use the winborder or default to 'single'
-- local border = vim.o.winborder == '' and 'single' or nil
-- TODO: make a toggle v vim.b.completion with nv.munchies.flag

-- Set the highlight priority to 20000 to beat the cursorline's default priority of 10000
---@param ctx blink.cmp.DrawItemContext
local component_highlight = function(ctx)
  return { { group = ctx.kind_hl, priority = 20000 } }
end

local M = {
  'Saghen/blink.cmp',
  event = 'InsertEnter',
  ---@type blink.cmp.Config
  opts = {
    cmdline = { enabled = false },
    completion = {
      accept = { auto_brackets = { enabled = true } },
      documentation = {
        auto_show = false,
        -- window = { border = border }
      },
      ghost_text = { enabled = false },
      trigger = {
        show_on_keyword = true,
        show_on_accept_on_trigger_character = true,
        show_on_x_blocked_trigger_characters = { '"', '(', '{', '[' },
      },
      list = { selection = { preselect = true, auto_insert = true } },
      menu = {
        auto_show = false,
        auto_show_delay_ms = 1000,
        ---@param ctx blink.cmp.Context
        ---@returns number the delay in milliseconds
        -- auto_show_delay_ms = function(ctx, _)
        --   if vim.tbl_contains({ '.', '/', "'" }, ctx.trigger.initial_character) then
        --     return 0
        --   end
        --   return 1337
        -- end,
        -- https://cmp.saghen.dev/recipes.html#avoid-multi-line-completion-ghost-text- border = border,
        direction_priority = function()
          local ctx = require('blink.cmp').get_context()
          local item = require('blink.cmp').get_selected_item()
          if ctx == nil or item == nil then
            return { 's', 'n' }
          end

          local item_text = item.textEdit ~= nil and item.textEdit.newText
            or item.insertText
            or item.label
          local is_multi_line = item_text:find('\n') ~= nil

          -- after showing the menu upwards, we want to maintain that direction
          -- until we re-open the menu, so store the context id in a global variable
          if is_multi_line or vim.g.blink_cmp_upwards_ctx_id == ctx.id then
            vim.g.blink_cmp_upwards_ctx_id = ctx.id
            return { 'n', 's' }
          end
          return { 's', 'n' }
        end,
        ---  @type blink.cmp.Draw
        draw = {
          treesitter = { 'lsp' },
          ---@ type blink.cmp.DrawColumnDefinition[]
          columns = {
            { 'source_id', 'kind_icon' },
            { 'label', 'label_description', gap = 1 },
          },
          ---@type table<string, blink.cmp.DrawComponent>
          components = {
            source_id = {
              ellipsis = false,
              text = function(ctx)
                return (nv.icons.src[ctx.source_id] or ' ') .. ctx.icon_gap
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
      },
    },
    fuzzy = { implementation = 'lua' },
    keymap = {
      ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
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
      window = {
        -- border = border,
        show_documentation = false,
      },
    },
  },
}

---@type table<string, blink.cmp.SourceProviderConfig>
local default_providers = {
  lsp = {
    score_offset = -1,
    ---@ param ctx blink.cmp.Context
    ---@ param items blink.cmp.CompletionItem[]
    transform_items = function(ctx, items)
      local kind = require('blink.cmp.types').CompletionItemKind
      -- local exclude = vim.tbl_map(function(name)
      --   return kind[name]
      -- end, { 'Keyword', 'Snippet' })
      local ret = vim.tbl_filter(function(item)
        return item.kind ~= kind.Keyword -- and item.kind ~= kind.Snippet
      end, items)
      --     return not (item.source ~= 'lazydev' and lazy_labels[item.label])
      return ret
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

local ft_sources = {
  lua = { 'lazydev' },
  r = { 'cmp_r' },
  rmd = { 'cmp_r' },
  quarto = { 'cmp_r' },
  sh = { 'env', 'lsp' },
  vim = { 'env', 'lsp' },
}

local providers = {
  buffer = {
    opts = {
      get_bufnrs = function()
        return vim.tbl_filter(function(bufnr)
          return vim.bo[bufnr].buftype == ''
        end, vim.api.nvim_list_bufs())
      end,
    },
  },
}

M.opts.sources = {
  ---@return blink.cmp.SourceList[]
  default = function()
    if nv.treesitter.is_comment() then
      return { 'buffer' }
    end
    local defaults = vim.tbl_keys(default_providers)
    return vim.list_extend(defaults, ft_sources[vim.bo.filetype] or {})
  end,

  -- TODO:  connect these to their respective repos
  providers = vim.tbl_extend('force', {}, providers, default_providers, {
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
  }),
}

return {
  M,
  { 'bydlw98/blink-cmp-env' },
  { 'Saghen/blink.compat' }, -- must be loaded before any cmp sources
  { 'R-nvim/cmp-r' },
}
