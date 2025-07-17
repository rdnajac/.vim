local M = { 'Saghen/blink.cmp' }

-- lazy.nvim
M.build = 'cargo build --release'

local plugin_name = M[1]:match('.*/(.*)')
local plugin_path = vim.fs.joinpath(pack_dir, plugin_name)

M.make = '!cd ' .. plugin_path .. ' && ' .. M.build
-- print(M, 'make command:', M.make)

M.dependencies = {
  'mgalliou/blink-cmp-tmux',
  'fang2hou/blink-copilot',
  'moyiz/blink-emoji.nvim',
  'bydlw98/blink-cmp-env',
}

M.event = 'InsertEnter'

---@module "blink.cmp"
---@type blink.cmp.Config
M.opts = {
  cmdline = { enabled = false },
  completion = {
    accept = { auto_brackets = { enabled = true } },
    documentation = { auto_show = true, window = { border = 'single' } },
    list = { selection = { preselect = true, auto_insert = true } },
    menu = {
      auto_show = true,
      border = 'single',
      draw = {
        treesitter = { 'lsp' },
        columns = { { 'kind_icon' }, { 'label', 'label_description', gap = 1 } },
        components = {
          kind_icon = {
            text = function(ctx)
              local kind_icons = require('snacks.picker.config.defaults').defaults.icons.kinds
              return kind_icons[ctx.kind] or ''
            end,
          },
        },
      },
    },
  },
  -- fuzzy = { sorts = { 'exact', 'score', 'sort_text' } },
  signature = { enabled = true, window = { border = 'single' } },
  keymap = {
    preset = 'default',
    ['<Tab>'] = {
      function(cmp)
        if cmp.snippet_active() then
          return cmp.snippet_forward()
        elseif cmp.is_visible() then
          return cmp.select_and_accept()
        else
          return cmp.show()
        end
      end,
      'fallback',
    },
    ['<Up>'] = { 'select_prev', 'fallback' },
    ['<Left>'] = { 'select_prev', 'fallback' },
    ['<Down>'] = { 'select_next', 'fallback' },
    ['<Right>'] = { 'select_next', 'fallback' },
  },

  sources = {
    default = { 'lsp', 'snippets', 'path', 'env' },
    per_filetype = {
      lua = { inherit_defaults = true, 'lazydev' },
      oil = {},
    },
    min_keyword_length = 5,
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
      --   opts = { max_completions = 2 },
      -- },
      lsp = {
        score_offset = 1,
        transform_items = function(_, items)
          return vim.tbl_filter(function(item)
            return item.kind ~= require('blink.cmp.types').CompletionItemKind.Keyword
              and item.kind ~= vim.lsp.protocol.CompletionItemKind.Snippet
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
        -- should_show_items = function(ctx)
        --   local col = ctx.cursor[2]
        --   local before = ctx.line:sub(1, col)
        --   return before:match('%$[%w_]*$') ~= nil
        -- end,
        --
      },
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

M.config = function()
  require('blink.cmp').setup(M.opts)
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
end

return M
