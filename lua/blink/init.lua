---@module "blink.cmp"
-- `https://main.cmp.saghen.dev`

return {
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
        auto_show_delay_ms = function(ctx, _)
          return vim.tbl_contains(
            { '.', '/', "'", '@', '$', ':', '"', '`', '[', ']' },
            ctx.trigger.initial_character
          ) and 1 or 1000
        end,
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
        ---@return boolean? true on success, nil otherwise
        function(cmp)
          cmp = cmp or require('blink.cmp')
          if cmp.snippet_active() then
            -- if vim.snippet.active() then
            return cmp.accept()
          else
            return cmp.select_and_accept()
          end
        end,
        'snippet_forward',
        function() return package.loaded['sidekick'] and require('sidekick').nes_jump_or_apply() end,
        function() return vim.lsp.inline_completion.get() end,
        'fallback',
      },
    },
    signature = { enabled = true, window = { show_documentation = false } },
    sources = require('blink.sources'),
  },
}

-- local aug = vim.api.nvim_create_augroup('HideInlineCompletion', {})
-- vim.api.nvim_create_autocmd('User', {
--   group = aug,
--   pattern = 'BlinkCmpMenuOpen',
--   callback = function() toggle_inline_completion:toggle() end,
-- })

-- vim.api.nvim_create_autocmd('User', {
--   group = aug,
--   pattern = 'BlinkCmpMenuClose',
--   callback = function() toggle_inline_completion:toggle() end,
-- end,
