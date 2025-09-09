local Workspace = require('nvim.lsp.lazydev.workspace')

local M = {}

M.debug = function()
  local buf = vim.api.nvim_get_current_buf()
  local ws = Workspace.find({ buf = buf })
  if not ws then
    return Snacks.notify.warn(
      'No **LuaLS** workspace found.\nUse `:LazyDev lsp` to see settings of attached LSP clients.'
    )
  end
  ws:debug({ details = true })
end

M.lsp = function()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  local lines = {} ---@type string[]
  for _, client in ipairs(clients) do
    lines[#lines + 1] = '## ' .. client.name
    lines[#lines + 1] = '```lua'
    lines[#lines + 1] = 'settings = ' .. vim.inspect(client.settings)
    lines[#lines + 1] = '```'
  end
  Snacks.notify.info(lines)
end

return M
