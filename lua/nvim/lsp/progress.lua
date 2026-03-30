local M = {}

---@alias nv.lsp.Progress {title?: string, message?: string, kind: "begin"|"report"|"end", percentage?: number}

---@type table<string, string> -- Maps progress ID to message ID
local progress = {}
---@type table<string, string> -- Maps progress ID to status
local prog_status = {}

--- handler for the LSP progress notification
--- see `:h LspProgress`
---@param ev { data: { client_id: integer, params: lsp.ProgressParams } }
function M.callback(ev)
  local id = ev.data.client_id
  local name = vim.lsp.get_client_by_id(id).name
  local token, value = ev.data.params.token, ev.data.params.value --[[@as nv.lsp.Progress]]
  local is_end = value.kind == 'end'
  local title = table.concat({
    '[' .. (name or 'LSP') .. ']', -- `[LSP]`
    is_end and '' or Snacks.util.spinner(),
    value.title, -- rest of the title
  }, ' ')
  local msg = not is_end and value.message or '100% done'
  local uri = ('%s:%s'):format(name, token)
  local opts = {
    kind = 'progress',
    source = vim.lsp.get_client_by_id(id).name,
    title = title,
    status = is_end and 'success' or 'running',
    percent = value.percentage,
    verbose = false,
  }
  if not progress[uri] then
    progress[uri] = vim.api.nvim_echo({ { msg } }, false, opts)
  else
    opts.id = progress[uri]
    vim.api.nvim_echo({ { msg } }, false, opts)
  end
  vim.cmd.redrawstatus()
end

--- exposes the status for a given progress ID (format: "client_name:token") for use in statuslines, etc.
---@param prog_id string
---@return string?
-- M.get_status = function(prog_id) return prog_status[prog_id] end

--- Check if there are any progress messages for a given client ID
---@param client_id integer
---@return boolean
M.get_msgs_by_client_id = function(client_id)
  local client = vim.lsp.get_client_by_id(client_id)
  if not client then return false end
  local name = client.name
  for uri, _ in pairs(progress) do
    if uri:match('^' .. name .. ':') then
      return true
    end
  end
  return false
end

return M
