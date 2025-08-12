---@type snacks.scratch.Config
return {
  template = "local x = \nprint(x)",
  ---@type table<string, snacks.win.Config>
  win_by_ft = {
    vim = {
      keys = {
        ['source'] = {
          '<CR>',
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
