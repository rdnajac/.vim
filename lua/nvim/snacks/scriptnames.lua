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

Snacks.picker({
  title = 'Scriptnames',
  items = items,
  format = function(item)
    return { { item.text } }
  end,
  layout = {
    preset = 'ivy',
  },
  sort = { fields = { 'idx' } },
})
