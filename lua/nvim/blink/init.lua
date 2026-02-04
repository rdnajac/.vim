-- TODO: no snippets in middle of word
-- `https://cmp.saghen.dev/`
local providers = require('nvim.blink.providers')
local sources = {
  ---@return blink.cmp.SourceList[]
  default = function()
    return vim.tbl_filter(
      function(src) return require('nvim.treesitter').is_comment() and src ~= 'snippets' or true end,
      vim.tbl_keys(providers) -- capture default providers
    )
  end,
  per_filetype = {
    lua = { inherit_defaults = true, 'lazydev' },
    -- sql = { 'dadbod' },
  },
}

-- -- add LazyDev provider if available
-- if pcall(require, 'lazydev.integrations.blink') then
providers.lazydev = {
  name = 'LazyDev',
  module = 'lazydev.integrations.blink',
  score_offset = 100,
}
-- end

local extras = require('nvim.blink.extras')

sources.providers = vim.iter(extras):fold(
  providers,
  function(acc, _, config) return vim.tbl_extend('force', acc, config) end
)

local get_providers = function(mode)
  mode = (mode or vim.api.nvim_get_mode().mode):sub(1, 1)
  local cmp_mode = ({ c = 'cmdline', t = 'terminal' })[mode] or 'default'
  return vim.tbl_keys(require('blink.cmp.sources.lib').get_enabled_providers(cmp_mode))
end

local blink_spec = {
  'Saghen/blink.cmp',
  -- TODO: build on initial install
  build = 'BlinkCmp build',
  event = 'UIEnter',
  ---@module "blink.cmp"
  ---@type blink.cmp.Config
  opts = {
    cmdline = { enabled = false },
    completion = {
      accept = { auto_brackets = { enabled = true } },
      documentation = { auto_show = false },
      ghost_text = { enabled = false },
      -- keyword = {},
      list = { selection = { preselect = true, auto_insert = true } },
      trigger = {
        show_on_keyword = true,
        show_on_accept_on_trigger_character = true,
        show_on_x_blocked_trigger_characters = { '"', '(', '{', '[' },
      },
      menu = require('nvim.blink.completion').menu,
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
      -- enabled = false, -- default = is `true`
      -- window = { show_documentation = false },
      -- TODO: check this
    },
    sources = sources, -- configured above
  },
}

return {
  specs = vim.list_extend({ blink_spec }, vim.tbl_keys(extras)),
  -- statusline component showing active completion sources
  status = {
    function()
      return vim
        .iter(get_providers())
        :map(function(provider) return nv.icons.blink[provider] or ' ' end)
        :join(' ')
    end,
    cond = function() return package.loaded['blink.cmp'] and vim.fn.mode():sub(1, 1) == 'i' end,
  },
}
