Snacks.picker.files({
  cwd = vim.fn.stdpath('config') .. '/doc',
  layout = { preset = 'insert' },
  confirm = function(p, item)
    confirm = function(z, item)
      dd(item)
      -- p:close()
      Snacks.zen({ win = { file = item.item.file } })
    end
  end,
})
