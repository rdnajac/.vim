local M = {}

---@alias nv.lsp.Progress {title?: string, message?: string, kind: "begin"|"report"|"end", percentage?: number}

-- -@type table<integer, table<lsp.ProgressToken, nv.lsp.Progress>>

local prog_msgs = {}

---@param ev { data: { client_id: integer, params: lsp.ProgressParams } }
function M.callback(ev)
  local value = ev.data.params.value --[[@as nv.lsp.Progress]]
  -- if type(value) ~= 'table' then return end
  local id, token = ev.data.client_id, ev.data.params.token
  prog_msgs[id] = prog_msgs[id] or {}
  prog_msgs[id][token] = value.kind ~= 'end' and value.message or nil

  local name = vim.lsp.get_client_by_id(ev.data.client_id).name
  M.echo(value, name)
end

---@param client_id integer
---@return string
-- M.get_msgs_by_client_id = function(client_id) return vim.iter(prog_msgs[client_id] or {}):totable() end
M.get_msgs_by_client_id = function(client_id) return vim.iter(prog_msgs[client_id] or {}):join(' ') end

---:h LspProgress
---@param v nv.lsp.Progress
---@param lsp? string
M.echo = function(v, lsp)
  lsp = lsp or 'LSP'
  local is_end = v.kind == 'end'
  vim.api.nvim_echo({ { is_end and 'done' or v.message } }, false, {
    id = 'lsp',
    kind = 'progress',
    title = table.concat({
      '[' .. lsp .. ']',
      is_end and '' or Snacks.util.spinner(),
      -- (v.percentage and v.percentage or '100') .. '%',
      v.title,
    }, ' '),
    status = is_end and 'success' or 'running',
    percent = v.percentage,
  })
end

return M
