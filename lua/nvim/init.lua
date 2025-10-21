_G.nv = _G.nv or require('nvim.util')

local plugins = require('nvim.plugins')

-- ---@type vim.pack.Spec[]
-- nv.specs = vim
--   .iter(plugins)
--   :map(function(p)
--     return nv.plug(p):tospec()
--   end)
--   :totable()

-- PERF:
nv.specs = vim.tbl_values(vim.tbl_map(function(plugin)
  return nv.plug(plugin):tospec()
end, plugins))

-- local vim_plugins = vim.is_list(vim.g.plugs) and vim.g.plugs
-- or vim.tbl_map(function(plug)
--   return plug.uri
-- end, vim.tbl_values(vim.g.plugs or {}))

local vim_plugins = vim.tbl_map(function(plug)
  return 'http://github.com/' .. plug .. '.git'
end, vim.g.plugs_order or {})

---@param plug_data { spec: vim.pack.Spec, path: string }
local load = function(plug_data)
  local spec = plug_data.spec
  vim.cmd.packadd({ spec.name, bang = true, magic = { file = false } })
  if spec.data and vim.is_callable(spec.data.setup) then
    spec.data.setup()
  end
end

vim.pack.add(vim.list_extend(nv.specs, vim_plugins or {}), { load = load })

return {
  -- stylua: ignore
  init = function()
    _G.dd = function(...) Snacks.debug.inspect(...) end
    _G.bt = function(...) Snacks.debug.backtrace(...) end
    _G.p = function(...) Snacks.debug.profile(...) end
  end,
}
