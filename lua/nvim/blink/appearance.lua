---@module "blink-cmp"
---@type blink.cmp.Draw
return {
  treesitter = { 'lsp' },

  ---@type blink.cmp.DrawColumnDefinition[]
  columns = {
    { 'source_id', 'kind_icon' },
    { 'label', 'label_description' },
  },

  ---@type table<string, blink.cmp.DrawComponent>
  components = {
    source_id = {
      ellipsis = false,
      text = function(ctx)
        local provider = ctx.source_name:lower()
        local icon = require('nvim.ui.icons').blink[provider] or ' '
        return icon .. ctx.icon_gap
      end,
      ---@param ctx blink.cmp.DrawItemContext
      highlight = function(ctx)
        -- high priority to beat the cursorline
        return { { group = ctx.kind_hl, priority = 10001 } }
      end,
    },
    kind_icon = {
      text = function(ctx)
        local kind_icon, _, _ = MiniIcons.get('lsp', ctx.kind)
        return kind_icon
      end,
      -- highlight = function(ctx)
      --   local _, hl, _ = MiniIcons.get('lsp', ctx.kind)
      --   return hl
      -- end,
    },
    -- kind = {
    --   highlight = function(ctx)
    --     local _, hl, _ = MiniIcons.get('lsp', ctx.kind)
    --     return hl
    --   end,
    -- },
  },
}
