vim.cmd.runtime('vimrc')

if vim.env.PROF then
  vim.cmd.packadd('snacks.nvim')
  require('snacks.profiler').startup({
    -- startup = { event = 'UIEnter' },
  })
end

-- stylua: ignore start
_G.dd = function(...) Snacks.debug.inspect(...) end
_G.bt = function(...) Snacks.debug.backtrace(...) end
_G.p  = function(...) Snacks.debug.profile(...) end
-- stylua: ignore end

require('nvim').init()
-- require('lazy').init()
