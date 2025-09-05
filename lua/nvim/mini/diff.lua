local diff = require('mini.diff')
-- local signs = { add = '▎', change = '▎', delete = '' },
-- local signs = N.icons.git
diff.setup({ view = { style = 'number' } })
-- diff.setup({})

Snacks.toggle({
  name = 'Mini Diff Signs',
  get = function()
    return vim.g.minidiff_disable ~= true
  end,
  set = function(state)
    vim.g.minidiff_disable = not state
    if state then
      diff.enable(0)
    else
      diff.disable(0)
    end
    vim.defer_fn(function()
      -- vim.cmd([[redraw!]])
      -- vim.cmd.redraw({ bang = true })
      Snacks.util.redraw(vim.api.nvim_get_current_win())
    end, 200)
  end,
}):map('<leader>uG')

vim.keymap.set('n', '<leader>go', function()
  require('mini.diff').toggle_overlay(0)
end, { desc = 'Toggle mini.diff overlay' })
