local M = {}

local function items(pluginpath)
  local dirs = {}
  for _, dir in ipairs(vim.fn.glob(pluginpath .. '/*', true, true)) do
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

local function pick_plugin(pick, pluginpath)
  Snacks.picker.pick({
    title = 'Plugins',
    items = items(pluginpath),
    format = function(item)
      return { { item.text } }
    end,
    confirm = function(_, item)
      pick(item.item)
    end,
  })
end

-- Helper to resolve the plugin dir patH
local function resolve_plugin_path(custom_path)
  if custom_path then
    return custom_path
  elseif vim.g.plug_home and vim.fn.isdirectory(vim.g.plug_home) == 1 then
    return vim.g.plug_home
  else
    return vim.o.packpath:match('[^,]+')
  end
end

M.grep = function(opts)
  local pluginpath = resolve_plugin_path(opts and opts.pluginpath)
  pick_plugin(function(dir)
    Snacks.picker.grep(vim.tbl_extend('force', opts or {}, { cwd = dir }))
  end, pluginpath)
end

M.files = function(opts)
  local pluginpath = resolve_plugin_path(opts and opts.pluginpath)
  pick_plugin(function(dir)
    Snacks.picker.files(vim.tbl_extend('force', opts or {}, { cwd = dir }))
  end, pluginpath)
end

return M
