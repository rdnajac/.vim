local diff = require('mini.diff')
-- local signs = { add = '▎', change = '▎', delete = '' },

diff.setup({ view = { style = 'number' } })

local defer_redraw = function(t)
  vim.defer_fn(function()
    -- vim.cmd([[redraw!]])
    -- vim.cmd.redraw({ bang = true })
    Snacks.util.redraw(vim.api.nvim_get_current_win())
  end, t or 200)
end

Snacks.toggle({
  name = 'MiniDiff Signs',
  get = function()
    return vim.g.minidiff_disable ~= true
  end,
  set = function(state)
    vim.g.minidiff_disable = not state
    diff[state and 'enable' or 'disable'](0)
    defer_redraw()
  end,
}):map('<leader>uS')

Snacks.toggle({
  name = 'MiniDiff Overlay',
  get = function()
    local data = MiniDiff.get_buf_data(0)
    return data and data.overlay == true or false
  end,
  set = function(_)
    diff.toggle_overlay(0)
    -- defer_redraw()
  end,
}):map('<leader>uG')
