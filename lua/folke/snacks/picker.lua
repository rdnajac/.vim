local M = {}
M.debug = {
  -- scores = true,
  -- leaks = true,
  -- explorer = true,
  -- files = true,
  -- grep = true,
  -- proc = true,
  -- extmarks = true,
}

---@module "snacks"

--- Some picker sources (like keymaps and autocmds) have a default
--- confirm action that isn't as useful as just jumping to the file.
-- print('debugging...')
-- dd(item.item)
-- end

M.layouts = require('folke.snacks.picker.layouts')

M.sources = {
  keymaps = {
    ---@param p snacks.Picker
    ---@param item snacks.picker.Item
    confirm = function(p, item)
      if not nv.fn.is_nonempty_string(item.file) then
        local info = vim.fn.getscriptinfo({ sid = item.item.sid })
        item.file = info and info[1] and info[1].name
        item.pos = { item.item.lnum, 0 }
      end
      p:action({ 'jump' })
    end,
  },
  -- autocmds = { confirm =  },
  explorer = require('folke.snacks.picker.explorer'),
  files = require('folke.snacks.picker.defaults'),
  grep = require('folke.snacks.picker.defaults'),
  buffers = {
    layout = 'mylayout',
    input = { keys = { ['<C-x>'] = { 'bufdelete', mode = { 'n', 'i' } } } },
  },
  git_status = { layout = 'left' },
  help = { layout = 'ivy_split' },
  icons = { layout = { preset = 'insert' } },
  recent = {
    config = function(p) p.filter = {} end,
  },
  zoxide = { confirm = 'edit' },
}

return M
