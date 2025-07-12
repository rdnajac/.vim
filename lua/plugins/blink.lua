local M = { 'Saghen/blink.cmp' }

M.dependencies = {
  'mgalliou/blink-cmp-tmux',
  'fang2hou/blink-copilot',
  'moyiz/blink-emoji.nvim',
  'bydlw98/blink-cmp-env',
}

M.build = 'cargo build --release'
M.event = 'InsertEnter'
M.opts = function()
  vim.api.nvim_create_autocmd('User', {
    pattern = 'BlinkCmpAccept',
    callback = function(ev)
      local item = ev.data.item
      if item.kind == require('blink.cmp.types').CompletionItemKind.path then
        vim.defer_fn(function()
          require('blink.cmp').show()
        end, 1)
      end
    end,
    desc = 'Keep completing path on <Tab>',
  })

  ---@module "blink.cmp"
  ---@type blink.cmp.Config
  return {
    -- fuzzy = { sorts = { 'exact', 'score', 'sort_text' } },
    signature = { enabled = true },
    cmdline = { enabled = false },
    completion = {
      accept = { auto_brackets = { enabled = true } },
      documentation = { auto_show = true, auto_show_delay_ms = 200 },
      list = { selection = { preselect = false, auto_insert = true } },

      menu = {
        auto_show = true,
        draw = {
          treesitter = { 'lsp' },
          columns = { { 'kind_icon' }, { 'label', 'label_description', gap = 1 } },
          components = {
            kind_icon = {
              text = function(ctx)
                -- local kind_icons = require('nvim.ui.icons').kinds
                local kind_icons = require('snacks.picker.config.defaults').defaults.icons.kinds
                return kind_icons[ctx.kind] or ''
              end,
            },
          },
        },
      },
    },
    keymap = {
      ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
      ['<C-e>'] = { 'hide', 'fallback' },
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
      ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
      ['<Up>'] = { 'select_prev', 'fallback' },
      ['<Down>'] = { 'select_next', 'fallback' },
      ['<C-p>'] = {
        function(cmp)
          if cmp.is_menu_visible() then
            return cmp.select_prev()
          else
            -- return '<C-o>p'
            vim.cmd('normal! p')
          end
        end,
        'fallback_to_mappings',
      },
      ['<C-n>'] = { 'select_next', 'fallback_to_mappings' },
      ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
      ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
      ['<C-k>'] = {
        function(cmp)
          if cmp.is_menu_visible() then
            return cmp.select_prev()
          end
        end,
        'show_signature',
        'hide_signature',
        'fallback',
      },
      ['<C-j>'] = {
        function(cmp)
          if cmp.is_menu_visible() then
            return cmp.select_next()
          end
        end,
        'fallback',
      },
    },
    sources = {
      default = { 'lsp', 'snippets', 'path' },
      per_filetype = {
        lua = { inherit_defaults = true, 'lazydev' },
        -- sh = { inherit_defaults = true,  'env' },
        -- vim = { inherit_defaults = true, 'env' },
        oil = {},
      },
      min_keyword_length = 3,
      providers = {
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
          score_offset = 100,
          opts = { friendly_snippets = false },
          should_show_items = function(ctx)
            return ctx.trigger.initial_kind ~= 'trigger_character'
          end,
        },
        -- copilot = {
        --   name = 'copilot',
        --   module = 'blink-copilot',
        --   -- score_offset = 10,
        --   async = true,
        --   opts = { max_completions = 5 },
        -- },
        lsp = {
          score_offset = 1,
          transform_items = function(_, items)
            return vim.tbl_filter(function(item)
              return item.kind ~= require('blink.cmp.types').CompletionItemKind.Keyword
              -- and item.kind ~= vim.lsp.protocol.CompletionItemKind.Snippet
            end, items)
          end,
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
        -- env = {
        --   name = 'env',
        --   module = 'blink-cmp-env',
        --   score_offset = -5,
        --   opts = {
        --     item_kind = require('blink.cmp.types').CompletionItemKind.Variable,
        --     show_braces = false,
        --     show_documentation_window = true,
        --   },
        -- },
        -- emoji = {
        --   module = 'blink-emoji',
        --   name = 'emoji',
        --   score_offset = 20,
        -- },
        lazydev = {
          name = 'LazyDev',
          module = 'lazydev.integrations.blink',
          score_offset = 100,
        },
      },
    },
  }
end

M.config = function()
  require('blink.cmp').setup(M.opts())
end

return M
