local index = vim.fn.expand('$VIMRUNTIME/doc/index.txt')
local options = vim.fn.expand('$VIMRUNTIME/doc/options.txt')

local function to_lines(fname)
  local lines = {}
  local f = io.open(fname, 'r')
  if f then
    for line in f:lines() do
      table.insert(lines, line)
    end
    f:close()
  end
  return lines
end

local map = {}
local rev = {}
for _, line in ipairs(to_lines(index)) do
  local cmd, abbr = line:match('^|:(%w+)|%s+:(%w+).*$')
  if cmd then
    map[cmd] = abbr
    rev[abbr] = cmd
  end
end

print(rev['setl'])
print(map['write'])

for _, line in ipairs(to_lines(options)) do
  local long, short = line:match("^'(%w+)'%s+'(%w+)'")
  if long then
    print(long .. ': ' .. short)
    -- map[cmd] = abbr
    -- rev[abbr] = cmd
  end
end

-- capture text from commands
local function exec_lines(cmd)
  local out = vim.api.nvim_exec2(cmd, { output = true }).output
  return vim.split(out, '\n', { trimempty = true })
end

-- usage
for _, l in ipairs(exec_lines('highlight')) do
  print(l)
end

for _, l in ipairs(exec_lines('scriptnames')) do
  print(l)
end
