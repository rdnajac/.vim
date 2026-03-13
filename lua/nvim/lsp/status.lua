local M = setmetatable({}, {
  __call = function(M, ...) return M.status(...) end,
})

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
M.server_status = function(c)
  if c.name == 'copilot' then
    return copilot_status()
  end
  local status
  if c:is_stopped() then
    status = 'stopped'
  else
    local msg = nv.lsp.progress.get_msgs_by_client_id(c.id)
    if msg then
      return nv.ui.spinner() .. ' '
      -- status = 'busy'
    end
  end
  return nv.ui.icons.status[status or 'active'] .. ' '
end

---@param buf? number
M.attached = function(buf)
  return vim.lsp.get_clients({ bufnr = buf or vim.api.nvim_get_current_buf() })
end

M.status = function() return vim.iter(M.attached()):map(M.server_status):join(' ') end

return M
