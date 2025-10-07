local M = { 'Saghen/blink.cmp' }


-- M.build = 'cargo build --release'
-- M.build = ':BlinkCmp build'
-- TODO:
M.event = 'InsertEnter'
M.specs = {
  'Saghen/blink.compat',
  -- 'fang2hou/blink-copilot',
  'bydlw98/blink-cmp-env',
}

-- use the winborder or default to 'single'
local border = vim.o.winborder == '' and 'single' or nil
local kind = vim.lsp.protocol.SymbolKind
-- local kind = require('blink.cmp.types').CompletionItemKind

---@module "blink.cmp"
---@type blink.cmp.Config
M.opts = {
  cmdline = { enabled = false },
  completion = {
    accept = { auto_brackets = { enabled = true } },
    documentation = { auto_show = false, window = { border = border } },
    ghost_text = { enabled = false },
    trigger = {
      show_on_keyword = true,
      show_on_accept_on_trigger_character = true,
      show_on_x_blocked_trigger_characters = { '"', '(', '{', '[' },
    },
    list = { selection = { preselect = true, auto_insert = true } },
    menu = {
      auto_show = true,
      -- auto_show_delay_ms = 1000,
      --- @param ctx blink.cmp.Context
      --- @param items blink.cmp.CompletionItem[]
      auto_show_delay_ms = function(ctx, items)
        if vim.tbl_contains({ '.', '/', "'" }, ctx.trigger.initial_character) then
          return 0
        end
        return 1337
      end,
      border = border,
      draw = {
        treesitter = { 'lsp' },
        columns = {
          { 'kind_icon' },
          { 'label', 'label_description', gap = 1 },
          { 'source_name' },
          -- { 'source_id' },
        },
        components = {
          kind_icon = {
            text = function(ctx)
              return nv.icons.kinds[ctx.kind] or ''
            end,
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
    window = { border = border, show_documentation = false },
  },
  sources = {
    ---@return blink.cmp.SourceList[]
    default = function()
      if nv.treesitter.is_comment() then

        return { 'buffer' }
      end
      ---@type table<string, blink.cmp.SourceProviderConfig>
      local default_providers = {
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
          -- HIDE SNIPPETS AFTER TRIGGER CHARACTER ~
          should_show_items = function(ctx)
            return ctx.trigger.initial_kind ~= 'trigger_character'
          end,
        },
        -- TODO: hide all lsp items if lazydev items are present
        lsp = {
          score_offset = -1,
          transform_items = function(_, items)
            -- FILTER OUT KEYWORDS AND SNIPPETS FROM LSP
            return vim.tbl_filter(function(item)
              return item.kind == kind.Keyword
                and item.kind == kind.Snippet
                and item.kind == kind.Text
            end, items)
          end,
        },
      }
      local ft_sources = {
        lua = { 'lazydev' },
        r = { 'cmp_r' },
        rmd = { 'cmp_r' },
        quarto = { 'cmp_r' },
        sh = { 'env' },
        vim = { 'env' },
      }
      return vim.list_extend(vim.tbl_keys(default_providers), ft_sources[vim.bo.filetype] or {})
    end,
    providers = {
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
    },
  },
}

M.status = function()
  local ok, sources = pcall(require, 'blink.cmp.sources.lib')
  if not ok then
    return ''
  end

  local enabled = sources.get_enabled_providers('default')
  local source_icons = nv.icons.src

  return vim
    .iter(sources.get_all_providers())
    :filter(function(name)
      return enabled[name] ~= nil
    end)
    :map(function(name)
      return source_icons[name] or ''
    end)
    :join('')
end

return M
