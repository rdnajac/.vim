local M = {}

-- TODO:  don't show up in history?
local progress = vim.defaulttable()

---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
local function lsp_progress_callback(ev)
  local client = vim.lsp.get_client_by_id(ev.data.client_id)
  local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
  if not client or type(value) ~= 'table' then
    return
  end
  local p = progress[client.id]

  for i = 1, #p + 1 do
    if i == #p + 1 or p[i].token == ev.data.params.token then
      p[i] = {
        token = ev.data.params.token,
        msg = ('[%3d%%] %s%s'):format(
          value.kind == 'end' and 100 or value.percentage or 100,
          value.title or '',
          value.message and (' **%s**'):format(value.message) or ''
        ),
        done = value.kind == 'end',
      }
      break
    end
  end

  local msg = {} ---@type string[]
  progress[client.id] = vim.tbl_filter(function(v)
    return table.insert(msg, v.msg) or not v.done
  end, p)

  -- Snacks.notify.info(table.concat(msg, '\n'), {
  -- You can still use the snacks notifier without overriding
  -- vim.notify = Snacks.notifier.notify
  Snacks.notifier.notify(table.concat(msg, '\n'), vim.log.levels.INFO, {
    id = 'lsp_progress',
    title = client.name,
    opts = function(notif)
      notif.style = 'compact' --- use a style without a timestamp
      -- TODO: get the filetype assosciated withthe lsp, not the buffer
      -- local lsp_filetype = client.config.filetypes and client.config.filetypes[1] or 'txt'
      -- notif.icon = #progress[client.id] == 0 and nv.filetype.icons(lsp_filetype)
      notif.icon = #progress[client.id] == 0 and nv.icons.filetype[vim.bo.filetype]
        or Snacks.util.spinner()
    end,
  })
end

M.setup = function()
  vim.api.nvim_create_autocmd('LspProgress', {
    callback = lsp_progress_callback,
  })
end

return M
