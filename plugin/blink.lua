---@module 'blink.cmp'
---@type blink.cmp.Config
local opts = {
  keymap = { preset = 'super-tab' },
  cmdline = { enabled = false },
  -- term = { enabled = true },
  completion = {
    menu = {
      auto_show = function(_)
        return vim.fn.mode() ~= 'R'
      end,
    },
    accept = { auto_brackets = { enabled = false } },
    documentation = { auto_show = true },
    ghost_text = { enabled = false },
    -- keyword = {},
    list = {
      selection = {
        preselect = false,
        auto_insert = true,
      },
    },
    trigger = {
      show_on_keyword = true,
      show_on_accept_on_trigger_character = true,
    },
  },
  signature = { enabled = true, window = { show_documentation = false } },
  sources = {
    default = { 'lsp', 'path', 'snippets' },
    per_filetype = {
      ['lua'] = { inherit_defaults = true, 'lazydev' },
      -- ['sql'] = { inherit_defaults = false, 'dadbod' },
    },
    providers = {
      ['lazydev'] = {
        name = 'LazyDev',
        module = 'blink.lazy',
        score_offset = 100,
      },
    },
  },
}

-- opts.completion.menu.auto_show_delay_ms = function(ctx, _)
--   return vim.tbl_contains(
--     { '.', '/', "'", '@', '$', ':', '"', '`', '[', ']' },
--     ctx.trigger.initial_character
--   ) and 1 or 1000
-- end

opts.completion.menu.draw = {
  columns = {
    { 'source_id' },
    { 'label', 'label_description' },
    { 'kind', 'source_name', gap = 1 },
  },
  components = {
    source_id = {
      ellipsis = false,
      text = function(ctx)
        local provider = ctx.source_name:lower()
        local icon = provider == 'lsp' and MiniIcons.get('lsp', ctx.kind) or nv.ui.icons[provider]
        return (icon or '') .. ctx.icon_gap
      end,
      ---@param ctx blink.cmp.DrawItemContext
      highlight = function(ctx)
        -- high priority to beat the cursorline
        return { { group = ctx.kind_hl, priority = 10001 } }
      end,
    },
  },
  treesitter = { 'lsp' },
}

--
-- M.keymap = {
--   preset = 'enter',
--   -- preset = 'none',
--   -- overrides default `:h i_CTRL-R`
--   -- ['<C-R>'] = { function(cmp) return cmp.show({ providers = { 'registers' } }) end },
--   ['<C-x><C-r>'] = { function(cmp) return cmp.show({ providers = { 'registers' } }) end },
--   ['<C-x><C-x>'] = { function(cmp) return cmp.show({ providers = { 'snippets' } }) end },
--   ['<A-1>'] = { function(cmp) cmp.accept({ index = 1 }) end },
-- }
-- for i = 1, 9 do
--   M.keymap['<A-' .. i .. '>'] = { function(cmp) cmp.accept({ index = i }) end }
-- end
--
-- M.sources = {
--   providers = {
--     lsp = {
--       --   score_offset = -1,
--       --   transform_items = function(_, items)
--       --     return vim
--       --       .iter(items)
--       --       :filter(function(item)
--       --         return not vim.tbl_contains({
--       --           -- 'Snippet',
--       --           -- 'Keyword'
--       --         }, vim.lsp.protocol.CompletionItemKind[item.kind])
--       --       end)
--       --       :totable()
--       --   end,
--     },
--     path = {
--       score_offset = 100,
--       opts = {
--         get_cwd = function(_) return vim.fn.getcwd() end,
--         show_hidden_files_by_default = true,
--       },
--     },

require('blink.cmp').setup(opts)

---@type lsp.ClientCapabilities
local blink_capabilities = {
  textDocument = {
    completion = {
      completionItem = {
        snippetSupport = true,
        commitCharactersSupport = false, -- TODO:
        documentationFormat = { 'markdown', 'plaintext' },
        deprecatedSupport = true,
        preselectSupport = false, -- TODO:
        tagSupport = { valueSet = { 1 } }, -- deprecated
        insertReplaceSupport = true, -- TODO:
        resolveSupport = {
          properties = {
            'documentation',
            'detail',
            'additionalTextEdits',
            'command',
            'data',
            -- TODO: support more properties? should test if it improves latency
          },
        },
        insertTextModeSupport = {
          -- TODO: support adjustIndentation
          valueSet = { 1 }, -- asIs
        },
        labelDetailsSupport = true,
      },
      completionList = {
        itemDefaults = {
          'commitCharacters',
          'editRange',
          'insertTextFormat',
          'insertTextMode',
          'data',
        },
      },

      contextSupport = true,
      insertTextMode = 1, -- asIs
    },
  },
}

-- vim.lsp.config('*', {
--   capabilities = vim.tbl_deep_extend('force', vim.lsp.protocol.make_client_capabilities(), blink_capabilities),
-- })
