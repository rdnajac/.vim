-- local me = debug.getinfo(1, 'S').source:sub(2)
-- local dir = vim.fn.fnamemodify(me, ':p:h')
-- local files = vim.fn.globpath(dir, '*', false, true)

-- see `vim._defer_require
local _submodules = {
  blink = true,
  keys = true,
  lsp = true,
  mini = true,
  treesitter = true,
}

return setmetatable({}, {
  __index = function(t, k)
    -- print(k)
    if _submodules[k] then
      -- lazy load runtime modules in the `nv` namespace
      local mod = require('nvim.' .. k)
      rawset(t, k, mod)
      return mod
    else
      -- expose all utils on the `nv` module
      local mod = require('nvim.util')[k]
        rawset(t, k, mod)
        return mod
    end
  end,
})
