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
  layouts = require('nvim.snacks.picker.layouts'),
  sources = {
    autocmds = require('nvim.snacks.picker.nvimcfg'),
    buffers = {
      layout = 'mylayout',
      input = {
        keys = {
          ['<c-x>'] = { 'bufdelete', mode = { 'n', 'i' } },
        },
      },
      list = { keys = { ['D'] = 'bufdelete' } },
    },
    explorer = require('nvim.snacks.picker.explorer'),
    files = require('nvim.snacks.picker.defaults'),
    git_status = { layout = 'left' },
    grep = require('nvim.snacks.picker.defaults'),
    help = { layout = 'ivy_split' },
    icons = { layout = { preset = 'insert' } },
    keymaps = require('nvim.snacks.picker.nvimcfg'),
    recent = {
      config = function(p)
        p.filter = {}
      end,
    },
    zoxide = { confirm = 'edit' },
  },
}
