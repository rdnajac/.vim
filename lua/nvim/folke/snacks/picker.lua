return {
  debug = {
    -- scores = true,
    -- leaks = true,
    -- explorer = true,
    -- files = true,
    -- grep = true,
    -- proc = true,
    -- extmarks = true,
  },
  layouts = require('nvim.folke.snacks.picker.layouts'),
  sources = {
    -- autocmds = require('nvim.folke.snacks.picker.nvimcfg'),
    buffers = {
      layout = 'mylayout',
      input = {
        keys = {
          ['<c-x>'] = { 'bufdelete', mode = { 'n', 'i' } },
        },
      },
      list = { keys = { ['D'] = 'bufdelete' } },
    },
    explorer = require('nvim.folke.snacks.picker.explorer'),
    files = require('nvim.folke.snacks.picker.defaults'),
    git_status = { layout = 'left' },
    grep = require('nvim.folke.snacks.picker.defaults'),
    help = { layout = 'ivy_split' },
    icons = { layout = { preset = 'insert' } },
    keymaps = require('nvim.folke.snacks.picker.nvimcfg'),
    recent = {
      config = function(p)
        p.filter = {}
      end,
    },
    zoxide = { confirm = 'edit' },
  },
}
