-- Snacks.debug
_G.bt = function()
  Snacks.debug.backtrace()
end

_G.dd = function(...)
  return (function(...)
    return Snacks.debug.inspect(...)
  end)(...)
end

vim.print = _G.dd

-- Snacks.profiler
if vim.env.PROF then
  vim.opt.rtp:append(vim.g.lazypath .. '/snacks.nvim')
  ---@type snacks.profiler.Config
  local profiler = {
    startup = {
      -- event = 'VeryLazy',
      -- event = 'UIEnter',
    },
    presets = { startup = { min_time = 0, sort = false } },
  }
  require('snacks').profiler.startup(profiler)
end
