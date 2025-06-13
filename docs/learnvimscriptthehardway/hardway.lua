Snacks.picker.pick({
  finder = 'grep',
  hidden = true,
  ignored = true,
  follow = false,
  cwd = vim.fn.expand('$XDG_CONFIG_HOME/vim/docs/learnvimscriptthehardway'),
  confirm = function(picker, item)
    picker:close()
    vim.cmd('!open ' .. Snacks.picker.util.path(item))
  end,
})
