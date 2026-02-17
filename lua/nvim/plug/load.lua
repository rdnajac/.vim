---@param plug_data {spec: vim.pack.Spec, path: string}
local function _load(plug_data)
  --- Check if `plug_data.spec.data[key]` is a function and
  --- calls it if so, discarding hte return value
  ---@param key string
  local maybe = function(key)
    local fn = vim.tbl_get(plug_data.spec, 'data', key)
    if vim.is_callable(fn) then
      fn()
    end
  end
  -- run init for vim plugins or `package.preload` hijinks
  maybe('init')

  -- always `packadd`! since we guard against `vim_did_enter`
  vim.cmd.packadd({ plug_data.spec.name, bang = true })

  -- run setup for neovim plugins with `opts` tables
  maybe('setup')
end

return _load
