local M = {}

---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
local progress = vim.defaulttable()

---@type table<number, string>
local status = {}

function M.status()
  local segs = {}
  for _, s in pairs(status) do
    if s ~= '' then
      segs[#segs + 1] = s
    end
  end
  return table.concat(segs, ' ')
end

vim.api.nvim_create_autocmd('LspProgress', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local value = ev.data.params.value
    if not client or type(value) ~= 'table' then
      return
    end

    local p = progress[client.id]

    for i = 1, #p + 1 do
      if i == #p + 1 or p[i].token == ev.data.params.token then
        p[i] = {
          token = ev.data.params.token,
          msg = ('[%3d%%%%] %s%s'):format(
            value.kind == 'end' and 100 or value.percentage or 100,
            value.title or '',
            value.message and (' **%s**'):format(value.message) or ''
          ),
          done = value.kind == 'end',
        }
        break
      end
    end

    local msgs = {}
    progress[client.id] = vim.tbl_filter(function(item)
      table.insert(msgs, item.msg)
      return not item.done
    end, p)

    status[client.id] = #progress[client.id] == 0 and '' or table.concat(msgs, ' | ')
    vim.cmd('redrawstatus')
  end,
})

return M
