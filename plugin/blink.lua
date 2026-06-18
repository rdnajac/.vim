---@module 'blink.cmp'
---@type blink.cmp.Config
local opts = {
  keymap = { preset = 'super-tab' },
  cmdline = { enabled = false },
  term = { enabled = false },
  signature = { enabled = true, window = { show_documentation = false } },
  completion = {
    -- menu = require('blink').menu,
    accept = { auto_brackets = { enabled = false } },
    documentation = { auto_show = true },
    ghost_text = { enabled = false },
    -- keyword = {},
    list = {
      selection = {
	preselect = false,
	auto_insert = true,
      },
    },
    trigger = {
      show_on_keyword = true,
      show_on_accept_on_trigger_character = true,
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
}

Plug({
  { 'Saghen/blink.lib' }, ---@module "blink.lib"
  {
    'Saghen/blink.cmp',
    build = function() require('blink.cmp').build():wait(6e4) end,
    opts = opts,
  },
})
