local M = {}

local progress = vim.defaulttable()

---Process LSP progress event and return formatted progress data
---@param ev { data:  { client_id: integer, params: lsp.ProgressParams } }
---@return { client_id: integer, client_name: string, messages: string[], is_complete: boolean }?
function M.process_progress(ev)
  local client = vim.lsp.get_client_by_id(ev.data.client_id)
  local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
  if not client or type(value) ~= 'table' then
    return nil
  end
  local p = progress[client.id]

  for i = 1, #p + 1 do
    if i == #p + 1 or p[i].token == ev.data.params.token then
      p[i] = {
        token = ev.data.params.token,
        -- msg = ('[%3d%%] %s%s'):format(
        value.kind == 'end' and 100
          or value.percentage
          or 100,
        --   value.title or '',
        --   value.message and (' **%s**'):format(value.message) or ''
        -- ),
        msg = value.message,
        done = value.kind == 'end',
      }
      break
    end
  end

  local msg = {} ---@type string[]
  progress[client.id] = vim.tbl_filter(
    function(v) return table.insert(msg, v.msg) or not v.done end,
    p
  )

  return {
    client_id = client.id,
    client_name = client.name,
    messages = msg,
    is_complete = #progress[client.id] == 0,
  }
end

---@param ev { data:  { client_id: integer, params: lsp.ProgressParams } }
local function lsp_progress_callback(ev)
  local result = M.process_progress(ev)
  if not result then
    return
  end

  -- Snacks.notify.info(table.concat(result.messages, '\n'), {
  -- You can still use the snacks notifier without overriding
  -- vim.notify = Snacks.notifier.notify
  Snacks.notifier.notify(table.concat(result.messages, '\n'), vim.log.levels.INFO, {
    id = 'lsp_progress',
    title = result.client_name,
    opts = function(notif)
      notif.style = 'compact' --- use a style without a timestamp
      -- TODO: get the filetype assosciated withthe lsp, not the buffer
      -- local lsp_filetype = client.config.filetypes and client.config.filetypes[1] or 'txt'
      -- notif.icon = #progress[client.id] == 0 and nv.filetype.icons(lsp_filetype)
      notif.icon = result.is_complete and nv.icons.filetype[vim.bo.filetype]
        or Snacks.util.spinner()
    end,
    history = false, --- do not store in history
  })
end

vim.api.nvim_create_autocmd('LspProgress', {
  callback = function(ev)
    M.process_progress(ev)
    vim.cmd.redrawstatus()
  end,
})

---Get progress messages for a specific client
---@param client_id integer
---@return string[]
M.get = function(client_id)
  local p = progress[client_id]
  if not p or #p == 0 then
    return {}
  end
  return vim.tbl_map(function(v) return v.msg end, p)
end

return setmetatable(M, {
  __call = function(_, client_id) return M.get(client_id) end,
})
