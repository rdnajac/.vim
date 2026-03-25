local keys = function()
  return vim
    .iter(ipairs(keys or {}))
    :map(function(_, t)
      local icon, desc, key, action = unpack(t)
      return { icon = icon, desc = desc, key = key, action = action, hidden = false }
    end)
    :totable()
end

local function print_keys()
  local lines = {}
  for _, item in ipairs(keys or {}) do
    lines[#lines + 1] = string.format('%s  %-44s %s', item.icon, item.desc, item.key)
  end
  return table.concat(lines, '\n')
end
