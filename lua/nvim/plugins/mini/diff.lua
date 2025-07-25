local diff = require('mini.diff')

diff.setup({
  view = { style = 'number', signs = { add = '▎', change = '▎', delete = '' } },
})

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
      vim.cmd([[redraw!]])
    end, 200)
  end,
}):map('<leader>uG')

vim.keymap.set('n', '<leader>go', function()
  diff.toggle_overlay(0)
end, { desc = 'Toggle mini.diff overlay' })
