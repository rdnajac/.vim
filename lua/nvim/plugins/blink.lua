-- use the winborder or default to 'single'
-- local border = vim.o.winborder == '' and 'single' or nil
return {
  'Saghen/blink.cmp',
  event = 'InsertEnter',
  ---@type blink.cmp.Config
  opts = {
    cmdline = { enabled = false },
    completion = {
      accept = { auto_brackets = { enabled = true } },
      documentation = {
        auto_show = false,
        -- window = { border = border }
      },
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
        ---@param ctx blink.cmp.Context
        ---@returns number the delay in milliseconds
        -- auto_show_delay_ms = function(ctx, _)
        --   if vim.tbl_contains({ '.', '/', "'" }, ctx.trigger.initial_character) then
        --     return 0
        --   end
        --   return 1337
        -- end,
        -- https://cmp.saghen.dev/recipes.html#avoid-multi-line-completion-ghost-text- border = border,
        direction_priority = function()
          local ctx = require('blink.cmp').get_context()
          local item = require('blink.cmp').get_selected_item()
          if ctx == nil or item == nil then
            return { 's', 'n' }
          end

          local item_text = item.textEdit ~= nil and item.textEdit.newText
            or item.insertText
            or item.label
          local is_multi_line = item_text:find('\n') ~= nil

          -- after showing the menu upwards, we want to maintain that direction
          -- until we re-open the menu, so store the context id in a global variable
          if is_multi_line or vim.g.blink_cmp_upwards_ctx_id == ctx.id then
            vim.g.blink_cmp_upwards_ctx_id = ctx.id
            return { 'n', 's' }
          end
          return { 's', 'n' }
        end,
        draw = {
          treesitter = { 'lsp' },
          columns = {
            { 'kind_icon' },
            { 'label', 'label_description', gap = 1 },
            { 'source_name' },
            { 'source_id' },
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
      window = {
        -- border = border,
        show_documentation = false,
      },
    },
    sources = require('nvim.blink_sources')
  }
}
