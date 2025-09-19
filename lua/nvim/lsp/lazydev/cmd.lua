local Workspace = require('nvim.lsp.lazydev.workspace')

local M = {}

M.debug = function()
  local ws = Workspace.find({ buf = vim.api.nvim_get_current_buf() })
  if not ws then
    return Snacks.notify.warn('No **LuaLS** workspace found.')
  end
  ws:debug({ details = true })
end

-- TODO: add other debugs for other client fields
-- TODO: move to lsp/debug
M.lsp = function()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  for _, client in ipairs(clients) do
    -- Snacks.notify.info(vim.inspect(client.capabilities), {
    Snacks.notify.info(vim.inspect(client.settings), {
      id = 'lazydev_lsp',
      title = client.name,
      ft = 'lua',
      opts = function(notif)
        notif.icon = require('vimline').ft_icon()
      end,
    })
  end
end

return M
