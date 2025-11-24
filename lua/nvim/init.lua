local prefixes = {
  'nvim.util',
  'nvim',
  'nvim.plugins',
}

local stats = { hits = 0, misses = 0 }

_G.nv = setmetatable({
  _stats = function()
    return stats
  end,
}, {
  __index = function(t, k)
    for _, prefix in ipairs(prefixes) do
      local ok, mod = pcall(require, prefix .. '.' .. k)
      if ok then
        stats.hits = stats.hits + 1
        t[k] = mod
        return mod
      end
      stats.misses = stats.misses + 1
    end
    return nil
  end,
})

nv.specs = vim
  .iter({ 'snacks', 'lazy', 'lsp', 'treesitter', 'mini', 'plugins' })
  :map(function(mod)
    local m = require('nvim.' .. mod)
    return (m.spec and m.spec) or (vim.islist(m) and m) or { m }
  end)
  :flatten()
  :map(function(plugin)
    return nv.plug(plugin):tospec()
  end)
  :totable()

local vim_plugins = vim.islist(vim.g.plugs) and vim.g.plugs
  or vim.tbl_map(function(plug)
    return plug.uri
  end, vim.tbl_values(vim.g.plugs or {}))

vim.list_extend(nv.specs, vim_plugins)

vim.pack.add(nv.specs, {
  ---@param plug_data { spec: vim.pack.Spec, path: string }
  load = function(plug_data)
    local spec = plug_data.spec
    local name = spec.name
    vim.cmd.packadd({ args = { name }, bang = true, magic = { file = false } })
    if spec.data and vim.is_callable(spec.data.setup) then
      spec.data.setup()
    end
  end,
})

return {
  init = function()
    vim.o.pumblend = 0
    vim.o.pumborder = 'rounded'
    vim.o.pumheight = 10

    -- these must be set before extui is enabled
    vim.o.cmdheight = 0
    vim.o.winborder = 'rounded'
    require('vim._extui').enable({})
    require('nvim.tokyonight')

    vim.schedule(function()
      require('nvim.config')
    end)

    -- stylua: ignore start
    _G.dd = function(...) Snacks.debug.inspect(...) end
    _G.bt = function(...) Snacks.debug.backtrace(...) end
    _G.p  = function(...) Snacks.debug.profile(...) end
  end,
}
