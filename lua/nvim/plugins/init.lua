local submodules = nv.submodules()
local iter = vim.iter(submodules)
local plugins = iter:map(require):map(nv.fn.ensure_list):flatten():totable()

return plugins
