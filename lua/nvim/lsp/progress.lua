local M = {}

---@alias nv.lsp.Progress {title?: string, message?: string, kind: "begin"|"report"|"end", percentage?: number}

---@type table<integer, string>
local prog_msgs = {}

---@param msg string
---@param opts vim.api.keyset.echo_opts
local function echom(msg, opts) vim.api.nvim_echo({ { msg } }, false, opts) end

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
  local msg = value.message

  prog_msgs[id] = not is_end and msg or nil

  echom(is_end and '100% done' or (msg or ''), {
    -- id = ('%s:%s'):format(name, token),
    id = 'lsp',
    kind = 'progress',
    title = title,
    status = is_end and 'success' or 'running',
    percent = value.percentage,
    -- verbose = true,
  })

  vim.cmd.redrawstatus()
end

--- exposes the last progress message for a given client id f] for use in statuslines, etc.
---@param id integer
---@return string
M.get_msgs_by_client_id = function(id) return prog_msgs[id] end

return M
