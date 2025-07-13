local M = {}

local function chezmoi_items()
  local results = require('chezmoi.commands').list({
    args = {
      '--path-style',
      'absolute',
      '--include',
      'files',
      '--exclude',
      'externals',
    },
  })

  local items = {}
  for _, czFile in ipairs(results) do
    table.insert(items, {
      text = czFile,
      file = czFile,
    })
  end
  return items
end

function M.pick()
  -- Snacks.picker.pick({
  Snacks.picker.files({
    title = 'Chezmoi Files',
    -- cwd = os.getenv('HOME') .. '/.local/share/chezmoi',
    -- hidden = true,
    items = chezmoi_items(),
    confirm = function(picker, item)
      picker:close()
      require('chezmoi.commands').edit({
        targets = { item.text },
        args = { '--watch' },
      })
    end,
  })
end

return M.pick
