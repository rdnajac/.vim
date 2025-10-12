local result = vim.api.nvim_exec2('scriptnames', { output = true })
local lines = vim.split(result.output, '\n', { plain = true, trimempty = true })

local items = vim.tbl_map(function(line)
  local idx, path = line:match('^%s*(%d+):%s+(.*)$')
  if idx and path then
    return {
      formatted = path,
      text = string.format('%3d %s', idx, path),
      file = path,
      item = path,
      idx = tonumber(idx),
    }
  end
  return nil
end, lines)

-- Snacks.picker({
--   title = 'Scriptnames',
--   items = items,
--   -- format = function(item)
--   --   return { { item.text } }
--   -- end,
--   -- TODO: pretty print and include idx
--   layout = { preset = 'vscode', },
--   sort = { fields = { 'idx' } },
-- })
Snacks.picker({
  title = 'Scriptnames',
  items = items,
  format = function(item, picker)
    local ret = {} ---@type snacks.picker.Highlight[]
    local idx = string.format('%3d', item.idx or 0)
    -- prepend index with highlight and space
    ret[#ret + 1] = { idx, 'SnacksPickerIdx' }
    ret[#ret + 1] = { ' ' }
    -- reuse Snacks’ built-in filename formatter for consistent styling
    vim.list_extend(ret, require('snacks.picker.formatters').filename(item, picker))
    return ret
  end,
  layout = { preset = 'vscode' },
  sort = { fields = { 'idx' } },
})
