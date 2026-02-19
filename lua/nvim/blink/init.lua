---@module "blink.cmp"
--- `https://cmp.saghen.dev/`
local blink = {
  'Saghen/blink.cmp',
  -- TODO: build on initial install
  -- TODO: show completion menu on <C-R> in insert mode
  build = 'BlinkCmp build',
  event = 'UIEnter',
  ---@type blink.cmp.Config
  opts = {
    cmdline = { enabled = false },
    completion = {
      accept = { auto_brackets = { enabled = true } },
      documentation = { auto_show = false },
      ghost_text = { enabled = false },
      -- keyword = {},
      -- list = { selection = { preselect = true, auto_insert = true } },
      trigger = {
        show_on_keyword = true,
        show_on_accept_on_trigger_character = true,
        show_on_x_blocked_trigger_characters = { '"', '(', '{', '[' },
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
      -- enabled = false, -- default = is `true`
      -- window = { show_documentation = false },
      -- TODO: check this
    },
  },
}

-- local providers
--
--
-- ---@type blink.cmp.SourceConfigPartial
-- blink_specs.opts.sources = {
--   ---@return blink.cmp.SourceList[]
--   default = vim.tbl_keys(providers),
--   per_filetype = {
--     -- sql = i{ 'dadbod' }, -- TODO: ,
--     vim = { inherit_defaults = true, 'env' },
--   },
-- }
-- -- add LazyDev provider if available
-- -- if pcall(require, 'lazydev.integrations.blink') then
-- if vim.uv.fs_stat(vim.g['plug#home'] .. '/lazydev.nvim') then
--   providers.lazydev = {
--     name = 'LazyDev',
--     module = 'lazydev.integrations.blink',
--     score_offset = 100,
--   }
--   sources.per_filetype.lua = { inherit_defaults = true, 'lazydev' }
-- end
--
-- ---@type table<string, blink.cmp.SourceProviderConfigPartial>
-- local extras = {
--   ['bydlw98/blink-cmp-env'] = {
--     env = {
--       name = 'env',
--       module = 'blink-cmp-env',
--       score_offset = -5,
--       opts = {
--         item_kind = function() return require('blink.cmp.types').CompletionItemKind.Variable end,
--         show_braces = false,
--         show_documentation_window = true,
--       },
--     },
--   },
-- }
--
-- local specs = { blink_spec }
-- for name, config in pairs(extras) do
--   providers = vim.tbl_extend('force', roviders, config)
--   table.insert(specs, { name })
-- end
-- -- blink_specs.opts.
--
-- -- cond = function() return package.loaded['blink.cmp'] and vim.fn.mode():sub(1, 1) == 'i' end, },
--
return {
  after = function() require('nvim.blink.cmp') end,
  -- specs = specs,
  specs = { blink },
  status = require('nvim.blink.status'),
}
