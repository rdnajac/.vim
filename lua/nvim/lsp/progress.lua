-- vim.api.nvim_create_autocmd('LspProgress', {
--   group = vim.api.nvim_create_augroup('LspProgressGroup', { clear = true }),
--   callback = function(ev)
--     local value = ev.data.params.value
--     local msg = string.format(
--       '%s: %s [%s%%]',
--       value.title or 'LSP',
--       value.message or '',
--       value.percentage or 100
--     )
--     local opts =
--       { kind = 'progress', title = value.title, percent = value.percentage, status = 'running' }
--     if value.kind == 'begin' then
--       -- vim.api.nvim_echo({ { msg, 'MoreMsg' } }, true, opts)
--       Snacks.notify.info(msg)
--     elseif value.kind == 'report' then
--       -- vim.api.nvim_echo({ { msg, 'MoreMsg' } }, true, opts)
--       Snacks.notify(msg)
--       -- elseif value.kind == 'end' then
--       -- opts.percent = 100
--       -- opts.status = 'success'
--       -- vim.api.nvim_echo({ { msg, 'MoreMsg' } }, true, opts)
--       -- { { msg, 'OkMsg' } },
--       -- { kind = 'progress', title = value.title, percent = 100, status = 'success' }
--     end
--   end,
-- })

local progress = vim.defaulttable()
vim.api.nvim_create_autocmd('LspProgress', {
  ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
  callback = function(ev)
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

    Snacks.notify.info(table.concat(msg, '\n'), {
      id = 'lsp_progress',
      title = client.name,
      opts = function(notif)
        notif.icon = #progress[client.id] == 0 and ' ' or Snacks.util.spinner()
      end,
    })
  end,
})
Snacks.util.spinner()
