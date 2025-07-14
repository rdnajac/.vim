return {
  lualine_a = { { 'mode', separator = { right = '' } } },
  lualine_b = {
    {
      '%S',
      cond = function()
        local ok, res = pcall(vim.api.nvim_eval_statusline, '%S', {})
        return ok and res and res.str ~= ''
      end,
      separator = { right = '' },
    },
  },
  lualine_c = {
    { 'diff', symbols = LazyVim.config.icons.git },
    {
      function()
        local reg = vim.fn.reg_recording()
        return reg ~= '' and 'recording @' .. reg or ''
      end,
      color = { fg = '#ff3344', bg = 'NONE', gui = 'bold' },
    },
    Snacks.profiler.status(),
  },

  lualine_x = {},
  lualine_y = {},
  lualine_z = {
    {
      function()
        local highlighter = require('vim.treesitter.highlighter')
        local buf = vim.api.nvim_get_current_buf()
        if highlighter.active[buf] then
          return ' '
        end
        return ''
      end,
    },
    {
      function()
        for _, client in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
          if client.name == 'GitHub Copilot' then
            return LazyVim.config.icons.kinds.Copilot
          end
        end
        return ''
      end,
    },
    {
      function()
        return ''
      end,
      padding = { left = 0, right = 0 },
      cond = function()
        local clients = vim.lsp.get_clients({ bufnr = 0 })
        return #clients > 0
      end,
    },
    { require('spec.lualine.components.lsp_status') },
  },
}
local M = {}
local date = require('spec.lualine.components.time').date
M.active = {
  lualine_a = {
    {
      'diagnostics',
      symbols = require('nvim.ui.icons').diagnostics,
      always_visible = true,
      color = { bg = '#3b4261' },
      -- separator = { right = '🭛' },
      -- cond = function()
      --   local ft = vim.bo.filetype
      --   return ft ~= 'snacks_terminal' and ft ~= 'oil'
      -- end,
    },
  },
  lualine_b = {
    {
      require('spec.lualine.components.navic'),
      color = { bg = 'NONE' },
    },
  },
  lualine_z = { date },
}

-- extensions
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

