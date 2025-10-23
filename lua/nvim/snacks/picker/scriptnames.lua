---@type { idx: number, file : string }
local scriptnames = nv.exec.scriptnames()

Snacks.picker({
  title = 'Scriptnames',
  items = scriptnames,
  format = function(item, picker)
    ---@type snacks.picker.Highlight[]
    local fmt = require('snacks.picker.format').filename(item, picker)
    table.insert(fmt, 1, { string.format('%3d', item.idx or 0), 'SnacksPickerIdx' })
    return fmt
  end,
  layout = { preset = 'vscode' },
})
