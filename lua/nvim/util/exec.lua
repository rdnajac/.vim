local M = {}
M.cmd = {}
M.abr = {}
local index = vim.fn.expand('$VIMRUNTIME/doc/index.txt')
-- local options = vim.fn.expand('$VIMRUNTIME/doc/options.txt')

for line in io.lines(index) do
  local cmd, abr = line:match('^|:(%w+)|%s+:(%w+).*$')
  if cmd and abr then
    M.cmd[cmd] = abr
    M.abr[abr] = cmd
  end
end

M.exec = function(cmd)
  local res = vim.api.nvim_exec2(cmd, { output = true })
  return vim.split(res.output, '\n', { trimempty = true })
end

---@class highlightClass
---@field [1] string group name
---@field def? table<string, string> highlight definition
---@field link? string link target

---@type highlightClass[]
M.highlight = vim
  .iter(M.exec('highlight'))
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

return setmetatable(M, {
  __call = function(...)
    return M.exec(...)
  end,
})
