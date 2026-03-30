---@module "blink.cmp"
-- `https://main.cmp.saghen.dev`

local spec = {
  'Saghen/blink.cmp',
  build = function() vim.cmd([[BlinkCmp build]]) end,
  event = 'UIEnter',
  ---@type blink.cmp.Config
  opts = {
    cmdline = { enabled = false },
    completion = {
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
        auto_show = function(ctx)
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
          },
          components = {
            source_id = {
              ellipsis = false,
              text = function(ctx)
                local provider = ctx.source_name:lower()
                local icon = provider == 'lsp' and MiniIcons.get('lsp', ctx.kind)
                  or require('nvim.ui.icons').blink[provider]
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
    },
    keymap = {
      ['<Tab>'] = {
        function(cmp) return cmp.snippet_active() and cmp.accept() or cmp.select_and_accept() end,
        'snippet_forward',
        function() return package.loaded['sidekick'] and require('sidekick').nes_jump_or_apply() end,
        function() return vim.lsp.inline_completion.get() end,
        'fallback',
      },
      ['<C-R>'] = { function(cmp) return cmp.show({ providers = { 'registers' } }) end },
    },
    signature = { enabled = true, window = { show_documentation = false } },
    sources = require('blink.sources'),
  },
}

return spec
