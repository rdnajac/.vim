local M = {}

local lazy_plugin_dirs = function()
  local items = {}

  for _, dir in ipairs(vim.fn.glob(lazypath .. '/*', true, true)) do
    if vim.fn.isdirectory(dir) == 1 then
      table.insert(items, {
        text = vim.fn.fnamemodify(dir, ':t'),
        file = dir,
        item = dir,
      })
    end
  end
  return items
end

local pick_plugin = function(pick)
  Snacks.picker.pick({
    title = 'Lazy Plugins',
    items = lazy_plugin_dirs(),
    format = function(item)
      return { { item.text } }
    end,
    confirm = function(_, item)
      pick(item.item)
    end,
  })
end

M.grep = function()
  pick_plugin(function(dir)
    Snacks.picker.grep({ cwd = dir })
  end)
end

M.files = function()
  pick_plugin(function(dir)
    Snacks.picker.files({ cwd = dir })
  end)
end

return M
