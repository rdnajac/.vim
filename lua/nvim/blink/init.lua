-- TODO: no snippets in middle of word
-- `https://cmp.saghen.dev/`
local opts = require('nvim.blink.opts')
local providers = require('nvim.blink.providers')

opts.sources = {
  ---@return blink.cmp.SourceList[]
  default = function()
    return vim.tbl_filter(function(src)
      return require('nvim.treesitter').is_comment() and src ~= 'snippets' or true
    end, vim.tbl_keys(providers))
  end,
  per_filetype = {
    lua = { inherit_defaults = true, 'lazydev' },
    -- sql = { 'dadbod' },
  },
}

-- if pcall(require, 'lazydev.integrations.blink') then
providers.lazydev = {
  name = 'LazyDev',
  module = 'lazydev.integrations.blink',
  score_offset = 100,
}
-- end

local spec = {
  {
    'Saghen/blink.cmp',
    opts = opts,
    -- event = 'InsertEnter',
    build = 'BlinkCmp build',
  },
}

local extras = require('nvim.blink.extras')

opts.sources.providers = vim.iter(extras):fold(providers, function(acc, repo, config)
  table.insert(spec, { repo })
  return vim.tbl_extend('force', acc, config)
end)

local M = {}

M.spec = spec

local get_providers = function(mode)
  mode = (mode or vim.api.nvim_get_mode().mode):sub(1, 1)
  local cmp_mode = ({ c = 'cmdline', t = 'terminal' })[mode] or 'default'
  return vim.tbl_keys(require('blink.cmp.sources.lib').get_enabled_providers(cmp_mode))
end

M.status = {
  function()
    return vim
      .iter(get_providers())
      :map(function(provider)
        return nv.icons.blink[provider] or ' '
      end)
      :join(' ')
  end,
  cond = function()
    return package.loaded['blink.cmp'] and vim.fn.mode():sub(1, 1) == 'i'
  end,
}

return M
