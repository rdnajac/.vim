---@param plug_data {spec: vim.pack.Spec, path: string}
local load_package = function(plug_data)
  local spec = plug_data.spec
  vim.cmd.packadd({ spec.name, bang = vim.v.vim_did_enter == 0 })
  local data = spec.data
  if not data then
    return
  end
  if vim.is_callable(data.init) then
    data.init(spec.name)
  end
  if data.toggle then
    for key, toggle in pairs(data.toggle) do
      nv.keys.toggles[key] = toggle
    end
  end
end

return load_package
