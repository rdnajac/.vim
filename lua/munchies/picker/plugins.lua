local M = {}

local vim_plug_home = vim.g.plug_home or vim.fn.stdpath('data') .. '/plugged'
local nvim_pack_path = vim.fn.stdpath('data') .. '/site/pack/core/opt'

local function resolve_plugin_path(bang)
  if bang and vim.fn.isdirectory(nvim_pack_path) == 1 then
    return nvim_pack_path
  else
    return vim_plug_home
  end
end

---@param plugdir string Directory path containing plugins
---@return table List of tables with fields: text, file, item
local function items(plugdir)
  local dirs = {}
  for _, dir in ipairs(vim.fn.glob(plugdir .. '/*', true, true)) do
    if vim.fn.isdirectory(dir) == 1 then
      table.insert(dirs, {
        text = vim.fn.fnamemodify(dir, ':t'),
        file = dir,
        item = dir,
      })
    end
  end
  return dirs
end

--- Opens a plugin picker with a callback on selection.
---@param picker function Callback function to handle the selected plugin.
---@param bang string Optional bang character to determine the plugin path.
local function pick_plugin(picker, bang)
  Snacks.picker.pick({
    title = 'Plugins',
    items = items(resolve_plugin_path(bang)),
    format = function(item)
      return { { item.text } }
    end,
    confirm = function(_, item)
      picker(item.item)
    end,
  })
end

--- Opens a grep picker for plugins.
--- @param opts table|nil Optional parameters passed to grep and pick_plugin.
function M.grep(opts)
  pick_plugin(function(dir)
    Snacks.picker.grep(vim.tbl_extend('force', opts or {}, { cwd = dir }))
  end, opts and opts.bang)
end

--- Opens a file picker for plugins.
--- @param opts table|nil Optional parameters passed to files and pick_plugin.
function M.files(opts)
  pick_plugin(function(dir)
    Snacks.picker.files(vim.tbl_extend('force', opts or {}, { cwd = dir }))
  end, opts and opts.bang)
end

return M
