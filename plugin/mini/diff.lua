require('mini.diff').setup({ view = { style = 'number' } })

Snacks.toggle
  .new({
    name = 'MiniDiff Signs',
    get = function() return vim.g.minidiff_disable ~= true end,
    set = function(state)
      vim.g.minidiff_disable = not state
      MiniDiff.toggle(0)
      require('nvim.ui').redraw()
    end,
  })
  :map('<leader>uG')

Snacks.toggle
  .new({
    name = 'MiniDiff Overlay',
    get = function()
      local data = MiniDiff.get_buf_data(0)
      return data and data.overlay == true or false
    end,
    set = function(_)
      MiniDiff.toggle_overlay(0)
      require('nvim.ui').redraw()
    end,
  })
  :map('<leader>go')
