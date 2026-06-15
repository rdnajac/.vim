return vim
  .iter(require('tokyonight.groups').plugins)
  :fold({ all = false }, function(acc, name, plugin)
    if
      vim.uv.fs_stat(vim.env.PACKDIR .. '/' .. name)
      or (
        vim.startswith(name, 'mini')
        and vim.tbl_contains({
          'diff',
          -- 'hipatterns',
          -- 'icons',
        }, name:sub(6))
      )
    then
      return rawset(acc, plugin, true)
    else
      return acc
    end
  end)
