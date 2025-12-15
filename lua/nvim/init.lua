_G.nv = require('nvim.util')

nv.treesitter = require('nvim.treesitter')
nv.lsp = require('nvim.lsp')

require('nvim.mini')
require('nvim.config')

--- @generic T
--- @param root string
--- @param mod T
--- @return T
local function _defer_require(root, mod)
  return setmetatable({ _submodules = mod }, {
    ---@param t table<string, any>
    ---@param k string
    __index = function(t, k)
      if not mod[k] then
        return
      end
      local name = string.format('%s.%s', root, k)
      t[k] = require(name)
      return t[k]
    end,
  })
end

local plugins = require('nvim.plugins')

vim.tbl_map(function(name)
  nv[name] = require('nvim.' .. name)
  local spec = nv[name].spec
  vim.list_extend(plugins, spec)
end, { 'lazy', 'lsp', 'treesitter' })

nv.specs = vim
  .iter(plugins)
  :map(function(p)
    return nv.plug(p):tospec()
  end)
  :totable()

nv.init = function()
  vim.pack.add(nv.specs, {
    ---@param plug_data {spec: vim.pack.Spec, path: string}
    load = function(plug_data)
      local spec = plug_data.spec
      vim.cmd.packadd({ spec.name, bang = true, magic = { file = false } })
      if spec.data and vim.is_callable(spec.data.setup) then
        -- print('setup ' .. spec.name)
        spec.data.setup()
      end
    end,
  })
end

return nv
