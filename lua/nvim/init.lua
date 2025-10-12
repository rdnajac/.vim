_G.nv = _G.nv or require('nvim.util')
nv.config = require('nvim.config')
nv.specs = vim.g.plugins or {}
nv.keys = {}

nv.for_each_submodule('nvim', 'plugins', function(m)
  local speclist = vim.islist(m) and m or { m }
  vim.tbl_map(function(t)
    local p = nv.plug(t)
    if p.enabled ~= false then
      nv.specs[#nv.specs + 1] = p:tospec()
      nv.keys[p.name] = p.keys
    end
  end, speclist)
end)

---@param plug_data { spec: vim.pack.Spec, path: string }
local function _load(plug_data)
  local spec = plug_data.spec
  -- local path = plug_data.path
  vim.cmd.packadd({ spec.name, bang = true, magic = { file = false } })
  -- local setup = spec.data and spec.data.setup
  local setup = spec.data and spec.data.setup
  if setup and vim.is_callable(setup) then
    setup()
  end
end

vim.pack.add(nv.specs, { load = _load })
