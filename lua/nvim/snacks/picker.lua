---@module "snacks"
---@type snacks.picker.Config
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
  layout = { preset = 'mylayout' },
  layouts = { mylayout = require('nvim.snacks.picker.layout') },
  sources = {
    buffers = {
      input = {
        keys = {
          ['<c-x>'] = { 'bufdelete', mode = { 'n', 'i' } },
        },
      },
      list = { keys = { ['D'] = 'bufdelete' } },
    },
    explorer = require('nvim.snacks.explorer'),
    autocmds = require('nvim.snacks.picker.util').pick_conf,
    keymaps = require('nvim.snacks.picker.util').pick_conf,
    files = require('nvim.snacks.picker.util').opts_extend,
    grep = require('nvim.snacks.picker.util').opts_extend,
    icons = {
      -- TODO: add '`insert-mode layout' to config
      layout = {
        layout = {
          reverse = true,
          relative = 'cursor',
          row = 1,
          width = 0.3,
          min_width = 48,
          height = 0.3,
          border = 'none',
          box = 'vertical',
          { win = 'input', height = 1, border = 'rounded' },
          { win = 'list', border = 'rounded' },
        },
      },
    },
    zoxide = { confirm = 'edit' },
  },
}
