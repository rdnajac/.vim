local M = {}
local plugins = {}

local this_file = debug.getinfo(1, 'S').source:sub(2)
local this_dir = vim.fs.dirname(vim.fs.normalize(this_file))
local topmod = vim.fn.substitute(this_dir, '.*/lua/', '', '')

for name, type_ in vim.fs.dir(this_dir) do
  print(name)
  local modname
  if name:sub(-4) == '.lua' then
    modname = name:sub(1, -5) -- strip .lua
  elseif type_ == 'link' or type_ == 'directory' then
    modname = name
  end

  if modname and modname ~= 'init' then
    plugins[#plugins + 1] = topmod .. '.' .. modname
  end
end

print(vim.inspect(plugins))
