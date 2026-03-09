---@module "blink.cmp"
--- `https://cmp.saghen.dev/`

-- FIXME:
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

---@type plug.Spec
return {
  'Saghen/blink.cmp',
  build = function() vim.cmd([[BlinkCmp build]]) end,
  event = 'UIEnter',
  ---@type blink.cmp.Config
  -- NOTE: non-default options are commented out
  opts = {
    cmdline = { enabled = false },
    completion = {
      -- accept = { auto_brackets = { enabled = false } },
      documentation = { auto_show = false },
      ghost_text = { enabled = false },
      -- keyword = {},
      -- list = { selection = { preselect = false, auto_insert = true } },
      trigger = {
        -- show_on_keyword = true,
        show_on_accept_on_trigger_character = true,
        -- show_on_x_blocked_trigger_characters = { '"', '(', '{', '[' },
      },
      -- menu = require('nvim.blink.appearance').menu,
    },
    -- fuzzy = { implementation = 'lua' },
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
      -- TODO: show completion menu on <C-R> in insert mode
      -- ['<C-r>'] = { function(cmp) cmp.show({ providers = { 'registers' } }) end },
    },
    signature = {
      enabled = true,
      window = { show_documentation = false },
    },
    sources = require('nvim.blink.sources'),
  },
}
