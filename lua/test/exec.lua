local M = {}

---@class highlightClass
---@field [1] string group name
---@field def? table<string, string> highlight definition
---@field link? string link target

---@return highlightClass[]
function M.highlight()
  return vim
    .iter(require('nvim.util').exec('highlight'))
    :map(function(line)
      local group, def = line:match('^(%S+)%s*xxx%s(.*)$')
      if group and def then
        return { group, def }
      end
    end)
    :map(function(t)
      local group, def = t[1], t[2]
      if vim.startswith(def, 'links to ') then
        local target = def:match('links to (%S+)')
        return { group = group, link = target }
      else
        local hl_def = {}
        for key, value in def:gmatch('(%w+)=([^%s]+)') do
          hl_def[key] = value
        end
        return { group = group, def = hl_def }
      end
    end)
    :totable()
end

print(M.highlight())

return M
