--- init.lua
T1 = vim.uv.hrtime()
vim.loader.enable()

-- vim.cmd([[ source ~/.vim/vimrc ]])
vim.cmd.source('~/.vim/vimrc')

vim.o.cmdheight = 0
require('vim._core.ui2').enable({
  -- msg = { target = 'msg' },
})

package.preload['lazy.stats'] = function()
  local startuptime = (vim.uv.hrtime() - T1) / 1e6
  return {
    stats = function()
      local count = #vim.fn.readdir(vim.env.PACKDIR)
      -- local loaded = #vim.tbl_filter(function(p) return not p.active end, vim.pack.get())
      local loaded = _G.setup_count or 0
      return { count = count, loaded = loaded, startuptime = startuptime }
    end,
  }
end

-- stylua: ignore
local dashkeys = {
  { action = ':ene | star',                desc = 'New File',       icon = ' ', key = 'n' },
  { action = ':PlugUpdate',                desc = 'Update Plugins', icon = ' ', key = 'U' },
  { action = ':Mason',                     desc = 'Mason',          icon = ' ', key = 'M' },
  { action = ':LazyGit',                   desc = 'LazyGit',        icon = '󰒲 ', key = 'G' },
  { action = ':News',                      desc = 'News',           icon = ' ', key = 'N' },
  { action = ':packloadall|checkhealth',   desc = 'Health',         icon = ' ', key = 'H' },
  { action = ':edit $MYVIMRC | :cd %:p:h', desc = 'Edit Dashboard', icon = '󱥰 ', key = 'D' },
  { action = ':restart',                   desc = 'Restart',        icon = '',  key = 'R' },
}

require('snacks').setup({
  -- bigfile = { enabled = true },
  dashboard = {
    enabled = true,
    preset = { keys = dashkeys },
    sections = {
      { section = 'header' },
      { section = 'keys' },
      { section = 'terminal', cmd = '$HOME/.vim/scripts/cowsay.sh' },
      { section = 'startup' },
    },
  },
  explorer = { replace_netrw = true, trash = true },
  image = { enabled = true },
  indent = { indent = { only_current = false, only_scope = true } },
  input = { enabled = true },
  -- notifier = require('munchies.notifier'),
  quickfile = { enabled = true },
  picker = require('munchies.picker'),
  scope = { enabled = true },
  scroll = { enabled = true },
  -- statuscolumn = require('munchies.statuscolumn'),
  styles = { lazygit = { height = 0, width = 0 } },
  toggle = { which_key = false },
  words = { enabled = true },
})

_G.dd = Snacks.debug.inspect
_G.bt = Snacks.debug.backtrace
_G.p = Snacks.debug.profile

require('nvim')
