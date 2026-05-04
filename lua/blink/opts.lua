---@module "blink.cmp"

---@type blink.cmp.Config
local M = {
  cmdline = { enabled = false },
  signature = { enabled = true, window = { show_documentation = false } },
}

M.completion = {
  -- accept = { auto_brackets = { enabled = false } },
  documentation = { auto_show = true },
  ghost_text = { enabled = false },
  -- keyword = {},
  -- list = { selection = { preselect = false, auto_insert = true } },
  trigger = {
    -- show_on_keyword = true,
    show_on_accept_on_trigger_character = true,
    -- show_on_x_blocked_trigger_characters = { '"', '(', '{', '[' },
  },
  menu = {
    -- auto_show = false,
    auto_show = function(_)
      -- don't show in replace mode
      return vim.fn.mode():sub(1, 1) ~= 'R'
    end,
    -- auto_show_delay_ms = function(ctx, _)
    --   return vim.tbl_contains(
    --     { '.', '/', "'", '@', '$', ':', '"', '`', '[', ']' },
    --     ctx.trigger.initial_character
    --   ) and 1 or 1000
    -- end,
    draw = {
      columns = {
        { 'source_id' },
        { 'label', 'label_description' },
        -- { 'kind', 'source_name' },
      },
      components = {
        source_id = {
          ellipsis = false,
          text = function(ctx)
            local provider = ctx.source_name:lower()
            local icon = provider == 'lsp' and MiniIcons.get('lsp', ctx.kind)
              or require('nvim.ui.icons')[provider]
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
    },
  },
}

M.fuzzy = {
  sorts = {
    function(a, b)
      if a.source_id ~= 'registers' or b.source_id ~= 'registers' then
        return
      end
      if a.sortText == nil or b.sortText == nil or a.sortText == b.sortText then
        return
      end
      return a.sortText < b.sortText
    end,
    'score',
    'sort_text',
  },
}

M.keymap = {
  -- overrides default `:h i_CTRL-R`
  -- ['<C-R>'] = { function(cmp) return cmp.show({ providers = { 'registers' } }) end },
  ['<C-x><C-r>'] = { function(cmp) return cmp.show({ providers = { 'registers' } }) end },
  ['<C-x><C-x>'] = { function(cmp) return cmp.show({ providers = { 'snippets' } }) end },
  ['<A-1>'] = { function(cmp) cmp.accept({ index = 1 }) end },
  ['<A-2>'] = { function(cmp) cmp.accept({ index = 2 }) end },
  ['<A-3>'] = { function(cmp) cmp.accept({ index = 3 }) end },
  ['<A-4>'] = { function(cmp) cmp.accept({ index = 4 }) end },
  ['<A-5>'] = { function(cmp) cmp.accept({ index = 5 }) end },
  ['<A-6>'] = { function(cmp) cmp.accept({ index = 6 }) end },
  ['<A-7>'] = { function(cmp) cmp.accept({ index = 7 }) end },
  ['<A-8>'] = { function(cmp) cmp.accept({ index = 8 }) end },
  ['<A-9>'] = { function(cmp) cmp.accept({ index = 9 }) end },
}

M.sources = {
  default = { 'lsp', 'path', 'snippets' },
  per_filetype = {
    ['lua'] = { inherit_defaults = true, 'lazydev' },
    ['sql'] = { inherit_defaults = false, 'dadbod' },
  },
  providers = {
    lsp = {
      --   score_offset = -1,
      --   transform_items = function(_, items)
      --     return vim
      --       .iter(items)
      --       :filter(function(item)
      --         return not vim.tbl_contains({
      --           -- 'Snippet',
      --           -- 'Keyword'
      --         }, vim.lsp.protocol.CompletionItemKind[item.kind])
      --       end)
      --       :totable()
      --   end,
    },
    path = {
      score_offset = 100,
      opts = {
        get_cwd = function(_) return vim.fn.getcwd() end,
        show_hidden_files_by_default = true,
      },
    },
    snippets = {
      -- score_offset = 99,
      opts = { friendly_snippets = false },
      -- https://cmp.saghen.dev/recipes.html#hide-snippets-after-trigger-character
      -- TODO: no snippets in middle of word
      should_show_items = function(ctx)
        if require('nvim.util').is_comment() then
          return false
        else
          return ctx.trigger.initial_kind ~= 'trigger_character'
        end
      end,
    },
    -- define custom providers below
    ['dadbod'] = {
      name = 'dadbod',
      module = 'vim_dadbod_completion.blink',
    },
    ['env'] = {
      name = 'env',
      module = 'blink.env',
    },
    ['lazydev'] = {
      name = 'LazyDev',
      module = 'blink.lazy',
      score_offset = 100,
    },
    ['registers'] = {
      name = 'registers',
      module = 'blink.registers',
    },
  },
}

-- local active_sources = function()
--   return vim.iter(require('blink.cmp.sources.lib').get_enabled_providers(
--         ({ c = 'cmdline', t = 'term' })[vim.fn.mode():sub(1, 1)] or 'default'
--       )):totable()
-- end

return M
