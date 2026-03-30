local copilot_status = function()
  local status
  if package.loaded['sidekick'] then
    local sidekick_status = require('sidekick.status').get()
    if sidekick_status then
      status = sidekick_status.busy == true and 'Warning' or sidekick_status.kind
    end
  else
    -- FIXME:
    status = 'Normal'
  end
  local icon = nv.ui.icons.copilot[status or 'Inactive']
  return icon[1] .. ' '
end

---@param c vim.lsp.Client
return function(c)
  if c.name == 'copilot' then
    return copilot_status()
  end
  local status
  if c:is_stopped() then
    status = 'stopped'
  else
    -- local msg = require('nvim.lsp.progress').get_msgs_by_client_id(c.id)
    -- if msg then
    -- return nv.ui.spinner() .. ' '
    -- status = 'busy'
    -- end
  end
  return nv.ui.icons.status[status or 'active'] .. ' '
end
