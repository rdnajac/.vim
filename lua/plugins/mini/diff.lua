require('mini.diff').setup({
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
      require('mini.diff').enable(0)
    else
      require('mini.diff').disable(0)
    end
    vim.defer_fn(function()
      vim.cmd([[redraw!]])
    end, 200)
  end,
}):map('<leader>uG')

-- { '<leader>go', function() require('mini.diff').toggle_overlay(0) end, desc = 'Toggle mini.diff overlay' },
-- vim.keymap.set(
