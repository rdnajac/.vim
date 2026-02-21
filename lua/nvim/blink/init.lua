---@module "blink.cmp"
--- `https://cmp.saghen.dev/`

---@type plug.Spec
local blink = {
  'Saghen/blink.cmp',
  -- TODO: show completion menu on <C-R> in insert mode
  build = 'BlinkCmp build', -- FIXME: doesn't build on initial install
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
      menu = require('nvim.blink.appearance').menu,
    },
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
        function() return package.loaded['sidekick'] and require('sidekick').nes_jump_or_apply() end,
        function() return vim.lsp.inline_completion.get() end,
        'fallback',
      },
    },
    signature = {
      enabled = true,
      window = { show_documentation = false },
    },
    sources = {
      providers = require('nvim.blink.providers'),
      per_filetype = {
        -- sql = { 'dadbod' }, -- TODO: ,
        -- vim = { inherit_defaults = true, 'env' },
      },
    },
  },
}

if vim.uv.fs_stat(vim.g['plug#home'] .. '/lazydev.nvim') then
  blink.opts.sources.providers.lazydev = {
    name = 'LazyDev',
    module = 'lazydev.integrations.blink',
    score_offset = 100,
  }
  blink.opts.sources.per_filetype.lua = { inherit_defaults = true, 'lazydev' }
end

local extras = nil -- TODO:

return {
  after = function() require('nvim.blink.cmp') end,
  specs = vim.list_extend({ blink }, extras or {}),
  status = require('nvim.blink.status'),
}
