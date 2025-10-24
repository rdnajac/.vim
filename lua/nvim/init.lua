_G.nv = _G.nv or require('nvim.util')

nv.specs = vim.tbl_values(vim.tbl_map(function(plugin)
  return nv.plug(plugin):tospec()
end, require('nvim.plugins')))

local vim_plugins = vim.tbl_map(function(plug)
  return 'http://github.com/' .. plug .. '.git'
end, vim.g.plugs_order or {})

---@param plug_data { spec: vim.pack.Spec, path: string }
local load = function(plug_data)
  local spec = plug_data.spec
  local name = spec.name
  vim.cmd.packadd({ args = { name }, bang = true, magic = { file = false } })
  if spec.data and vim.is_callable(spec.data.setup) then
    spec.data.setup()
  end
end

vim.pack.add(vim.list_extend(nv.specs, vim_plugins or {}), { load = load })

return {
  init = function()
    -- these require nvim nightly
    vim.o.pumblend = 0
    vim.o.pumborder = 'rounded'
    vim.o.pumheight = 10

    -- these must be set before extui is enabled
    vim.o.cmdheight = 0
    vim.o.winborder = 'rounded'
    -- FIXME: doesn't play nice with a fresh vim.pack.add
    require('vim._extui').enable({})

    -- run all `setup` functions in `nvim/config/*.lua` after startup
    vim.schedule(function()
      vim.o.winbar = '%{%v:lua.nv.winbar()%}'
      vim.tbl_map(require, nv.submodules('config'))
    end)
    -- stylua: ignore start
    _G.dd = function(...) Snacks.debug.inspect(...) end
    _G.bt = function(...) Snacks.debug.backtrace(...) end
    _G.p  = function(...) Snacks.debug.profile(...) end
  end,
}
