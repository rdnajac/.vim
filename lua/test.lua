  Snacks.explorer.open({
    cwd = Snacks.git.get_root() or vim.env.HOME,
    layout = {
      preview = true,
      layout = { position = 'bottom', height = 0.3 },
    },
  })
