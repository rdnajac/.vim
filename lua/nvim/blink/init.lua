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

local specs = {}

sources.providers = vim
  .iter(require('nvim.blink.specs'))
  :fold(providers, function(acc, repo, config)
    specs[#specs + 1] = repo
    return vim.tbl_extend('force', acc, config)
  end)

local get_providers = function(mode)
  mode = (mode or vim.api.nvim_get_mode().mode):sub(1, 1)
  local cmp_mode = ({ c = 'cmdline', t = 'terminal' })[mode] or 'default'
  return vim.tbl_keys(require('blink.cmp.sources.lib').get_enabled_providers(cmp_mode))
end

return {
  completion = require('nvim.blink.completion'),
  specs = specs,
  sources = sources,
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
