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

-- TODO: move to treesitter module
local function in_comment()
  local success, node = pcall(vim.treesitter.get_node)
  if success and node then
    return vim.tbl_contains({
      'comment',
      'line_comment',
      'block_comment',
      'comment_content',
    }, node:type())
  end
  return false
end

---@module "blink.cmp"
---@type blink.cmp.Config
M.opts = {
  fuzzy = { implementation = 'lua' },
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
        columns = {

          { 'kind_icon' },
          { 'label', 'label_description', gap = 1 },
          -- { 'source_name' },
          -- { 'source_id' },
        },
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
    ['<Left>'] = { 'select_prev', 'fallback' },
    ['<C-k'] = { 'select_prev', 'fallback' },
    ['<Down>'] = { 'select_next', 'fallback' },
    ['<Right>'] = { 'select_next', 'fallback' },
    ['<C-j>'] = { 'select_next', 'fallback' },
    ['<Tab>'] = {
      function(cmp)
        local item = cmp.get_selected_item()
        local type = require('blink.cmp.types').CompletionItemKind

        if cmp.is_visible() and item then
          -- if item.kind == type.Snippet then
          if item.kind == type.Path then
            cmp.accept()
            vim.defer_fn(function()
              cmp.show({ providers = { 'path' } })
            end, 1)
            return true
          else
            return cmp.accept()
          end
        end
      end,
      'fallback',
    },
  },
  sources = {
    default = function()
      local defaults = { 'lsp', 'snippets', 'path' }
      if in_comment() then
        return { 'buffer' }
      end
      --  ui
      if vim.bo.filetype == 'lua' then
        defaults = vim.list_extend({ 'lazydev' }, defaults)
      end
      return defaults
    end,
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
      lsp = {
        score_offset = 1,
        transform_items = function(_, items)
          return vim.tbl_filter(function(item)
            -- FILTER OUT KEYWORDS AND SNIPPETS FROM LSP
            return item.kind ~= kind.Keyword and item.kind ~= kind.Snippet
          end, items)
        end,
      },
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
      -- emoji = {
      --   module = 'blink-emoji',
      --   name = 'emoji',
      --   score_offset = 20,
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
    },
  },
}

M.config = function()
  require('blink.cmp').setup(M.opts)

  vim.keymap.set('i', '$', function()
    require('blink.cmp').show({ providers = { 'env' } })
    return '$'
  end, { expr = true, replace_keycodes = false })
end

return M
