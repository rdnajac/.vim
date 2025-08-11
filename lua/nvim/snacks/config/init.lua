---@module "snacks"
---@type snacks.Config
local M = {}

M.dashboard = require('nvim.snacks.config.dashboard')
M.picker = require('nvim.snacks.config.picker')

---@type snacks.explorer.Config
M.explorer = {
  replace_netrw = vim.g.default_file_explorer == 'snacks',
}

---@type snacks.indent.Config
M.indent = {
  indent = { only_current = true, only_scope = true },
}

---@type snacks.notifier.Config
M.notifier = {
  style = 'fancy',
  date_format = '%T',
  timeout = 4000,
}

---@type snacks.scratch.Config
M.scratch = {
  ---@type table<string, snacks.win.Config>
  win_by_ft = {
    vim = {
      keys = {
        ['source'] = {
          '<cr>',
          function(_)
            vim.cmd.source('%')
          end,
          desc = 'Source buffer',
          mode = { 'n', 'x' },
        },
      },
    },
  },
}

M.styles = {
  lazygit = { height = 0, width = 0 },
  terminal = {
    bo = { filetype = 'snacks_terminal' },
    wo = {},
    keys = {
      q = 'hide',
      gf = function(self)
        local f = vim.fn.findfile(vim.fn.expand('<cfile>'), '**')
        if f == '' then
          Snacks.notify.warn('No file under cursor')
        else
          self:hide()
          vim.schedule(function()
            vim.cmd('e ' .. f)
          end)
        end
      end,
      term_normal = {
        '<esc>',
        function(self)
          self.esc_timer = self.esc_timer or (vim.uv or vim.loop).new_timer()
          if self.esc_timer:is_active() then
            dd('started')
            self.esc_timer:stop()
            vim.cmd('stopinsert')
          else
            self.esc_timer:start(200, 0, function() end)
            return '<esc>'
          end
        end,
        mode = 't',
        expr = true,
        desc = 'Double escape to normal mode',
      },
    },
  },
}

---@type snacks.terminal.Config
M.terminal = {
  start_insert = true,
  auto_insert = true,
  auto_close = true,
  win = { wo = { winbar = '', winhighlight = 'Normal:SpecialWindow' } },
}

return M
