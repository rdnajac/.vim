_G.nv = _G.nv or require('nvim.util')

local M = {}

---@type vim.pack.Spec[]
nv.specs = vim
  .iter(nv.submodules('plugins'))
  :map(function(submod)
    return require(submod)
  end)
  :map(function(mod)
    return vim.islist(mod) and mod or { mod }
  end)
  :flatten()
  :map(nv.plug)
  :filter(function(p) ---@param p Plugin
    return p.enabled ~= false
  end)
  :map(function(p) ---@param p Plugin
    return p:tospec()
  end)
  :totable()

local plugins = {}
if vim.islist(vim.g.plugs) then
  plugins = vim.g.plugs or {}
else
  -- support vim-plug
  plugins = vim.tbl_map(function(p)
    return p.uri
  end, vim.tbl_values(vim.g.plugs) or {})
end

vim.pack.add(vim.list_extend(nv.specs, plugins or {}), {
  ---@param plug_data { spec: vim.pack.Spec, path: string }
  load = function(plug_data)
    local spec = plug_data.spec

    vim.cmd.packadd({ spec.name, bang = true, magic = { file = false } })

    if spec.data and vim.is_callable(spec.data.setup) then
      spec.data.setup()
    end
  end,
})

M.init = function() end

return M
