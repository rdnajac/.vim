local M = {}

M.scratch = {
  win_by_ft = {
    vim = {
      keys = {
        ['source'] = {
          '<CR>',
          function(self)
            local mode = vim.fn.mode()
            if mode == 'v' or mode == 'V' or mode == '\22' then
              vim.cmd("'<,'>PP")
            else
              vim.cmd('%PP')
            end
          end,
          desc = 'Evaluate with PP',
          mode = { 'n', 'x' },
        },
      },
    },
  },
}

return M
