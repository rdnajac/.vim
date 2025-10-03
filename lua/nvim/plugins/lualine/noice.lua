return {
  {
    function()
      return require('noice').api.status.command.get()
    end,
    cond = function()
      return package.loaded['noice'] and require('noice').api.status.command.has()
    end,
    color = function()
      return { fg = Snacks.util.color('Statement') }
    end,
  },
  {
    function()
      return require('noice').api.status.mode.get()
    end,
    cond = function()
      return package.loaded['noice'] and require('noice').api.status.mode.has()
    end,
    color = function()
      return { fg = Snacks.util.color('Constant') }
    end,
  },
}
