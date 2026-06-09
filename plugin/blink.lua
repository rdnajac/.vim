Plug({
  { 'Saghen/blink.lib' }, ---@module "blink.lib"
  {
    'Saghen/blink.cmp',
    build = function() require('blink.cmp').build():wait(6e4) end,
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      cmdline = { enabled = false },
      keymap = { preset = 'super-tab' },
      signature = { enabled = true, window = { show_documentation = false } },
      completion = {
        accept = { auto_brackets = { enabled = false } },
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
            return vim.fn.mode():sub(1, 1) ~= 'R' -- replace mode
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
                    or nv.ui.icons[provider]
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
    },
  },
})
