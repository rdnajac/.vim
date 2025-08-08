local M = {}

---@module "snacks"
-- see: Snacks.picker.picker_actions()

---@param picker snacks.Picker
M.toggle = function(picker)
  local cwd = picker:cwd()
  local alt = picker.opts.source == 'files' and 'grep' or 'files'
  picker:close()
  if alt == 'files' then
    Snacks.picker.files({ cwd = cwd })
  else
    Snacks.picker.grep({ cwd = cwd })
  end
end

return M
