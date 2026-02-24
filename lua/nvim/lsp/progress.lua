local M = {}

local Progress = vim.defaulttable()

---@param ev { data: { client_id: integer, params: lsp.ProgressParams } }
function M.handle(ev)
  local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin"|"report"|"end"}]]
  if type(value) ~= 'table' then
    return
  end

  local id, token = ev.data.client_id, ev.data.params.token
  Progress[id][token] = value.kind ~= 'end' and value.message or nil
end

---:h LspProgress
---@param ev { data: { client_id: integer, params: lsp.ProgressParams } }
M.echo = function(ev)
  local value = ev.data.params.value or {}
  local client = vim.lsp.get_client_by_id(ev.data.client_id)
  local is_end = value.kind == 'end'

  vim.api.nvim_echo({ { value.message or 'done' } }, false, {
    id = 'lsp',
    kind = 'progress',
    title = table.concat({
      '[' .. (client and client.name or 'LSP') .. ']',
      is_end and '' or Snacks.util.spinner(),
      value.title,
    }, ' '),
    status = is_end and 'success' or 'running',
    -- percent = value.percentage,
  })
end

---@param client_id integer
---@return string[]
M.get_msgs_by_client_id = function(client_id)
  local msgs = {}
  for _, msg in pairs(Progress[client_id]) do
    msgs[#msgs + 1] = msg
  end
  return msgs
end

return M
