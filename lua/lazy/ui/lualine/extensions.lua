local M = {}

M.checkhealth = {
  winbar = {},
  inactive_winbar = {},
  sections = {},
  tabline = {},
  filetypes = { 'checkhealth' },
}

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

M.oil = {
  inactive_winbar = {
    lualine_a = {
      function()
        local ok, oil = pcall(require, 'oil')
        if ok then
          return vim.fn.fnamemodify(oil.get_cursor_entry(), ':~')
        else
          return ''
        end
      end,
    },
  },
  filetypes = { 'oil' },
}

M.snacks_terminal = {
  sections = {
    lualine_a = {
      { 'mode', separator = { right = '' } },
    },
    lualine_b = {
      {
        function()
          local chan = vim.b.terminal_job_id or '?'
          return 'channel: ' .. tostring(chan)
        end,
        separator = { right = '' },
      },
    },
    lualine_c = {
      function()
        return vim.b.term_title or ''
      end,
    },
  },
  filetypes = { 'snacks_terminal' },
}

-- M.snacks_dashboard = {
--   inactive_winbar = {},
--   active_winbar = {},
--   filetypes = { 'snacks_dashboard' },
-- }

return M
