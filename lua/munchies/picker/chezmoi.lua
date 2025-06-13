local chezmoi_items = function()
  local ok, results = pcall(require('chezmoi.commands').list, {
    args = {
      '--path-style',
      'absolute',
      '--include',
      'files',
      '--exclude',
      'externals',
    },
  })
  if not ok then
    return {}
  end

  local items = {}
  for _, czFile in ipairs(results) do
    table.insert(items, {
      -- formatted = czFile,
      text = czFile,
      file = czFile,
      -- item = czFile,
    })
  end

  return items
end

Snacks.picker.pick({
  title = 'chezmoi files',
  items = chezmoi_items(),
  confirm = function(picker, item)
    picker:close()
    require('chezmoi.commands').edit({
      targets = { item.text },
      args = { '--watch' },
    })
  end,
})
