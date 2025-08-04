local M = { 'Saghen/blink.cmp' }

M.build = 'cargo build --release'

M.dependencies = {
  'bydlw98/blink-cmp-env',
  'fang2hou/blink-copilot',
  'mgalliou/blink-cmp-tmux',
  'moyiz/blink-emoji.nvim',
}

M.event = 'InsertEnter'

local kind = vim.lsp.protocol.SymbolKind
-- local kind = require('blink.cmp.types').CompletionItemKind

local function is_in_comment()
  local success, node = pcall(vim.treesitter.get_node)
  if not success or not node then
    return false
  end
  while node do
    if vim.tbl_contains({ 'comment', 'line_comment', 'block_comment', 'comment_content' }, node:type()) then
      return true
    end
    node = node:parent()
  end
  return false
end

---@module "blink.cmp"
---@type blink.cmp.Config
M.opts = {
  cmdline = { enabled = false },
  completion = {
    accept = { auto_brackets = { enabled = true } },
    -- documentation = { auto_show = true, window = { border = 'single' } },
    list = { selection = { preselect = true, auto_insert = true } },
    menu = {
      -- auto_show = true,
      -- border = 'single',
      draw = {
        treesitter = { 'lsp' },
        -- default
        -- columns = { { 'kind_icon' }, { 'label', 'label_description', gap = 1 } },
        -- indexed
        -- columns = { { 'item_idx' }, { 'kind_icon' }, { 'label', 'label_description', gap = 1 } },
        -- nvim-cmp style menu
        columns = { { 'label', 'label_description', gap = 1 }, { 'kind_icon', 'kind' } },
        components = {
          kind_icon = {
            text = function(ctx)
              return _G.icons.kinds[ctx.kind] or ''
            end,
          },
        },
      },
    },
  },
  signature = { enabled = true, window = { border = 'single' } },
  keymap = {
    ['<Up>'] = { 'select_prev', 'fallback' },
    ['<Down>'] = { 'select_next', 'fallback' },
    ['<Left>'] = { 'select_prev', 'fallback' },
    ['<Right>'] = { 'select_next', 'fallback' },
    ['<Tab>'] = {
      function(cmp)
        -- local ctx = cmp.get_context()
        local item = cmp.get_selected_item()
        -- if the menu is showing and its a snippet, accept and expand ot
        if cmp.is_visible() then
          if item and item.kind == require('blink.cmp.types').CompletionItemKind.Snippet then
            cmp.accept()
          else
            cmp.select_next()
          end
        end
        return ''
      end,
      'fallback',
    },
  },

  sources = {
    -- default = { 'lsp', 'snippets', 'path' },
    default = function(ctx)
      local success, node = pcall(vim.treesitter.get_node)
      if
        success
        and node
        and vim.tbl_contains({ 'comment', 'line_comment', 'block_comment', 'comment_content' }, node:type())
      then
        return { 'buffer' }
      else
        return { 'lsp', 'path', 'snippets' }
      end
    end,
    per_filetype = {
      lua = { inherit_defaults = true, 'lazydev' },
      oil = {},
    },
    -- min_keyword_leng = 5,
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
        -- HIDE SNIPPETS AFTER TRIGGER CHARACTER ~
        should_show_items = function(ctx)
          return ctx.trigger.initial_kind ~= 'trigger_character'
        end,
        -- transform_items = function(_, items)
        --   return vim.tbl_filter(function(item)
        --     return is_in_comment()
        --   end, items)
        -- end,
      },
      --
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
            return item.kind ~= kind.Keyword and item.kind ~= kind.Snippet
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
  -- XXX: THIS IS BROKEN
  -- vim.api.nvim_create_autocmd('User', {
  --   pattern = 'BlinkCmpAccept',
  --   callback = function(ev)
  --     local item = ev.data.item
  --     if item.kind == require('blink.cmp.types').CompletionItemKind.Path then
  --       vim.defer_fn(function()
  --         require('blink.cmp').show()
  --       end, 1)
  --     end
  --   end,
  --   desc = 'Keep completing path on <Tab>',
  -- })
  vim.keymap.set('i', '$', function()
    require('blink.cmp').show({ providers = { 'env' } })
    return '$'
  end, { expr = true, replace_keycodes = false })

  --   vim.keymap.set('i', '<Tab>', function()
  --     local cmp = require('blink.cmp')
  --     local ctx = cmp.get_context()
  --     local item = cmp.get_selected_item()
  --     -- if the menu is showing and its a snippet, accept and expand ot
  --     if cmp.is_visible() then
  --       if item and item.kind == require('blink.cmp.types').CompletionItemKind.Snippet then
  --         cmp.accept()
  --       else
  --         cmp.select_next()
  --       end
  --     else
  --       return '<Tab>'
  --     end
  --     return ''
  --   end, { expr = true })
end

return M
