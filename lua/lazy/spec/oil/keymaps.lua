-- Keymaps in oil buffer. Can be any value that `vim.keymap.set` accepts OR a table of keymap
-- options with a `callback` (e.g. { callback = function() ... end, desc = "", mode = "n" })
-- Additionally, if it is a string that matches "actions.<name>",
-- it will use the mapping at require("oil.actions").<name>
-- Set to `false` to remove a keymap
-- See :help oil-actions for a list of all available actions
---@diagnostic disable-next-line: unused-local
local defaults = {
  ['g?'] = { 'actions.show_help', mode = 'n' },
  ['<CR>'] = 'actions.select',
  ['<C-s>'] = { 'actions.select', opts = { vertical = true } },
  ['<C-h>'] = { 'actions.select', opts = { horizontal = true } },
  ['<C-t>'] = { 'actions.select', opts = { tab = true } },
  ['<C-p>'] = 'actions.preview',
  ['<C-c>'] = { 'actions.close', mode = 'n' },
  ['<C-l>'] = 'actions.refresh',
  ['-'] = { 'actions.parent', mode = 'n' },
  ['_'] = { 'actions.open_cwd', mode = 'n' },
  ['`'] = { 'actions.cd', mode = 'n' },
  ['~'] = { 'actions.cd', opts = { scope = 'tab' }, mode = 'n' },
  ['gs'] = { 'actions.change_sort', mode = 'n' },
  ['gx'] = 'actions.open_external',
  ['g.'] = { 'actions.toggle_hidden', mode = 'n' },
  ['g\\'] = { 'actions.toggle_trash', mode = 'n' },
}

local detail = 0

local keymaps = {
  ['q'] = { 'actions.close', mode = 'n' },
  ['<Tab>'] = { 'actions.close', mode = 'n' },
  ['<Left>'] = { 'actions.parent', mode = 'n' },
  ['<Right>'] = 'actions.select',
  ['h'] = { 'actions.parent', mode = 'n' },
  ['l'] = 'actions.select',
  ['Y'] = { 'actions.yank_entry', mode = 'n' },
  ['Z'] = {
    callback = function()
      Snacks.picker.zoxide({
        confirm = 'edit',
      })
    end,
  },
  ['gi'] = {
    desc = 'Toggle file detail view',
    callback = function()
      detail = (detail + 1) % 3
      local oil = require('oil')
      if detail == 0 then
        oil.set_columns({ 'icon' })
      elseif detail == 1 then
        oil.set_columns({ 'icon', 'permissions', 'size', 'mtime' })
      else
        oil.set_columns({})
      end
    end,
  },
}

return keymaps
