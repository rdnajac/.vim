Snacks.picker.files({
  cwd = vim.fn.stdpath('config') .. '/doc',
  layout = { preset = 'insert' },
  confirm = function(p, item)
    p:close()
    Snacks.zen({ win = { file = item._path } })
  end,
})
