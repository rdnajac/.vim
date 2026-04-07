--- init.lua
T1 = vim.uv.hrtime()
vim.loader.enable()

require('vim._core.ui2').enable({
  msg = { target = 'msg' },
})

vim.cmd([[
colorscheme tokyonight
source ~/.vim/vimrc
command! News exe 'e' nvim_get_runtime_file('doc/news.txt', v:false)[0]
]])

require('snacks').setup({
  dashboard = {
    sections = {
      { section = 'header' },
      {
        { icon = '󰱼 ', title = 'Files', { section = 'recent_files', indent = 2 } },
        { icon = ' ', desc = 'Health ', key = 'H', action = ':checkhealth' },
        { icon = '󰒲 ', desc = 'LazyGit', key = 'G', action = ':lua Snacks.lazygit()' },
        { icon = ' ', desc = 'Mason  ', key = 'M', action = ':Mason' },
        { icon = ' ', desc = 'News   ', key = 'N', action = ':News' },
        { icon = ' ', desc = 'Update ', key = 'U', action = ':lua vim.pack.update()' },
      },
      -- stylua: ignore
      { section = 'terminal', cmd = [[cowsay "The computing scientist's main challenge is not to get confused by the complexities of his own making"  | sed "s/^/        /" ]], },
      function() return { footer = 'NVIM ' .. tostring(vim.version()), padding = 1 } end,
    },
  },
  explorer = { replace_netrw = true, trash = true },
  image = { enabled = true },
  indent = { indent = { only_current = false, only_scope = true } },
  input = { enabled = true },
  -- notifier = require('munchies.notifier'),
  quickfile = { enabled = true },
  picker = {
    layouts = require('munchies.picker.layouts'),
    sources = {
      explorer = require('munchies.explorer'),
      files = require('munchies.picker.config'),
      grep = require('munchies.picker.config'),
      highlights = {
        --- enable mini.hipatterns in the preview buffer
        ---@param picker snacks.Picker
        on_show = function(picker)
          if MiniHipatterns then
            MiniHipatterns.enable(picker.preview.win.buf)
            -- Snacks.util.redraw(picker.preview.win.win)
          end
        end,
      },
      keymaps = {
        --- make confirm work with keymaps defined in vimscripts
        ---@param p snacks.Picker
        ---@param item snacks.picker.Item
        confirm = function(p, item)
          if not item.file then
            local info = vim.fn.getscriptinfo({ sid = item.item.sid })
            item.file = info and info[1] and info[1].name
            item.pos = { item.item.lnum, 0 }
          end
          p:action({ 'jump' })
        end,
      },
      recent = { config = function(p) p.filter = {} end },
    },
  },
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
_G.nv = require('nvim')
Plug(require('plugins'))
Plug(require('blink'))
