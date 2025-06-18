local M = {}

M.man = {
  winbar = {
    lualine_a = {
      function()
        return 'MAN'
      end,
    },
    lualine_b = { { 'filename', file_status = false } },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },
  filetypes = { 'man' },
}

M.snacks_terminal = {
  sections = {
    lualine_a = {
      function()
        local chan = vim.b.terminal_job_id or '?'
        return 'term channel: ' .. tostring(chan)
      end,
    },
  },
  filetypes = { 'snacks_terminal' },
}

return M
