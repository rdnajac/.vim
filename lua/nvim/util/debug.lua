local M = {}

local path = function()
  return (
    LazyVim.lualine.pretty_path({
      relative = 'root',
      modified_sign = '',
      length = 6,
      modified_hl = '',
      directory_hl = '',
      filename_hl = '',
    })()
  )
end

local print_func = 'print'
-- local print_func = 'dd'

M.insert = function()
  local file = path():gsub('^lua/', '')
  local line_nr = vim.fn.line('.')
  local print_stmt = line_nr == 1 and string.format("%s('%s')", print_func, file)
    or string.format("%s('%s: %d')", print_func, file, line_nr + 1)
  vim.cmd('normal! ' .. (line_nr == 1 and 'O' or 'o') .. print_stmt)
end

M.keys = function()
  local function command(lhs, cmd)
    return { lhs, '<Cmd>' .. cmd .. '<CR>' }
  end

  require('which-key').add({
    { '<leader>d', group = 'debug' },
    command('<leader>da', 'ALEInfo'),
    command('<leader>db', 'Blink status'),
    { '<leader>dc', ':=vim.lsp.get_clients()[1].server_capabilities<CR>', desc = 'LSP Capabilities' },
    command('<leader>dd', 'LazyDev debug'),
    command('<leader>dl', 'LazyDev lsp'),
    command('<leader>dL', 'checkhealth vim.lsp'),
    command('<leader>dh', 'LazyHealth'),
    { '<leader>dS', ':=require("snacks").meta.get()<CR>', desc = 'Snacks' },
    { '<leader>dw', ':=vim.lsp.buf.list_workspace_folders()<CR>', desc = 'LSP Workspace Folders' },
    {
      '<leader>D',
      function()
        require('nvim.util.debug').insert()
      end,
      desc = 'Insert Debug Print',
    },
  })
end

return M
