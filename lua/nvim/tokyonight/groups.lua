return {
  ---@param colors ColorScheme
  ---@param opts tokyonight.Config
  setup = function(colors, opts)
    local Util = require('tokyonight.util')
    local groups = vim.tbl_extend('force', {
      base = true,
      kinds = true,
      semantic_tokens = true,
      treesitter = true,
    }, require('nvim.tokyonight.plugins'))

    local names = vim.tbl_keys(groups)
    table.sort(names)

    local cache_key = opts.style
    local cache = opts.cache and Util.cache.read(cache_key)

    local inputs = {
      colors = colors,
      plugins = names,
      version = -1,
      opts = {
        transparent = opts.transparent,
        styles = opts.styles,
        dim_inactive = opts.dim_inactive,
      },
    }

    local ret = cache and vim.deep_equal(inputs, cache.inputs) and cache.groups

    if not ret then
      ret = {}
      -- merge highlights
      for plugin, v in pairs(groups) do
        local m = type(v) == 'string' and v or plugin
        ---@type tokyonight.HighlightsFn
        local get = require('tokyonight.groups.' .. m).get
        for k, v in pairs(get(colors, opts)) do
          ret[k] = v
        end
      end
      Util.resolve(ret)
      -- if opts.cache then
      Util.cache.write(cache_key, { groups = ret, inputs = inputs })
      -- end
    end

    -- local highlights = {
    --   Number = { fg = c.blue },
    --   Special = { fg = c.red, bold = true },
    --   SpellBad = { bg = c.red },
    --   Statement = { fg = c.red },
    --   ['@property'] = { fg = c.yellow },
    --   ['@keyword.function'] = { fg = c.red },
    --   ['@variable.parameter'] = { fg = c.magenta },
    --   ['@variable.member'] = { fg = c.blue },
    -- }

    return ret, groups
  end,
}
