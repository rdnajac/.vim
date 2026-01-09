---@type blink.cmp.Config
local opts = {
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
      function() return vim.lsp.inline_completion.get() end,
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
}

-- Set the highlight priority to 20000 to beat the cursorline's default priority of 10000
---@param ctx blink.cmp.DrawItemContext
local component_highlight = function(ctx) return { { group = ctx.kind_hl, priority = 20000 } } end

opts.completion.menu = {
  -- auto_show = true,
  auto_show_delay_ms = function(ctx, _)
    if vim.tbl_contains({ '.', '/', "'", '@' }, ctx.trigger.initial_character) then
      return 0
    end
    return 420
  end,

  -- https://cmp.saghen.dev/recipes.html#avoid-multi-line-completion-ghost-text- border = border,
  ---@diagnostic disable-next-line: assign-type-mismatch
  -- direction_priority = function()
  --   local cmp = require('blink.cmp')
  --   local ctx = cmp.get_context()
  --   local item = cmp.get_selected_item()
  --   if ctx and item then
  --     local item_text = (item.textEdit and item.textEdit.newText) or item.insertText or item.label
  --     -- local is_multi_line = item_text:find('\n') ~= nil
  --     -- after showing the menu upwards, we want to maintain that direction
  --     -- until we re-open the menu, so store the context id in a global variable
  --     -- if is_multi_line or vim.g.blink_cmp_upwards_ctx_id == ctx.id then
  --     if item_text:find('\n') or vim.g.blink_cmp_upwards_ctx_id == ctx.id then
  --       vim.g.blink_cmp_upwards_ctx_id = ctx.id
  --       return { 'n', 's' }
  --     end
  --   end
  --   return { 's', 'n' }
  -- end,

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
          local provider = ctx.source_name
          local icon = nv.icons.blink[provider] or ' '
          return icon .. ctx.icon_gap
        end,
        highlight = component_highlight,
      },
      kind_icon = {
        text = function(ctx) return nv.icons.kinds[ctx.kind] or '' end,
        highlight = component_highlight,
      },
    },
  },
}

return opts
