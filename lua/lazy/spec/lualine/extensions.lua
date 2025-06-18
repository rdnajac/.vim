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

M.oil = {
  winbar = {
    lualine_a = {
      function()
        local ok, oil = pcall(require, 'oil')
        if ok then
          return vim.fn.fnamemodify(oil.get_current_dir(), ':~')
        else
          return ''
        end
      end,
    },
  },
  filetypes = { 'oil' },
}

return M
