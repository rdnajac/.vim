---@module "snacks"

--- Some picker sources (like keymaps and autocmds) have a default
--- confirm action that isn't always as useful as just jumping to the
--- file. This function can be used to overrides that action.
--- @param p snacks.Picker
--- @param item snacks.picker.Item
local config_confirm = function(p, item)
  local file = item and item.file
  if not file or file == '' then
    Snacks.notify.warn('No file associated with this item')
    return
  end
  p:action('jump', file) -- TODO: make jump work for vimscript items
end

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
    autocmds = { confirm = config_confirm },
    keymaps = { confirm = config_confirm },
    files = require('nvim.snacks.picker.config').extend,
    grep = require('nvim.snacks.picker.config').extend,
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
