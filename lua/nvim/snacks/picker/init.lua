return {
  debug = {
    -- scores = true, -- show scores in the list
    -- leaks = true, -- show when pickers don't get garbage collected
    -- explorer = true, -- show explorer debug info
    -- files = true, -- show file debug info
    -- grep = true, -- show file debug info
    -- proc = true, -- show proc debug info
    -- extmarks = true, -- show extmarks errors
  },
  -- layout = { preset = 'mydefault' },
  layouts = require('nvim.snacks.picker.layouts'),
  sources = {
    autocmds = require('nvim.snacks.picker.nvimcfg'),
    buffers = {
      layout = 'mydefault',
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
