local M = {
  debug = {
    -- scores = true,
    -- leaks = true,
    -- explorer = true,
    -- files = true,
    -- grep = true,
    -- proc = true,
    -- extmarks = true,
  },
}

--- Some picker sources (like keymaps and autocmds) have a default
--- confirm action that isn't as useful as just jumping to the file.
--- @param p snacks.Picker
--- @param item snacks.picker.Item
local function config_confirm(p, item)
  if not nv.fn.is_nonempty_string(item.file) then
    local sid = item.item.sid
    local info = vim.fn.getscriptinfo({ sid = sid })
    item.file = info and info[1] and info[1].name
    item.pos = { item.item.lnum, 0 }
  end
  p:action({ 'jump' })
end

M.layouts = require('nvim.folke.snacks.picker.layouts')
M.sources = {
  -- autocmds = { confirm = config_confirm },
  buffers = {
    layout = 'mylayout',
    input = { keys = { ['<C-x>'] = { 'bufdelete', mode = { 'n', 'i' } } } },
  },
  explorer = require('nvim.folke.snacks.picker.explorer'),
  files = require('nvim.folke.snacks.picker.defaults'),
  git_status = { layout = 'left' },
  grep = require('nvim.folke.snacks.picker.defaults'),
  help = { layout = 'ivy_split' },
  icons = { layout = { preset = 'insert' } },
  keymaps = { confirm = config_confirm },
  recent = {
    config = function(p)
      p.filter = {}
    end,
  },
  zoxide = { confirm = 'edit' },
}

return M
