-- TODO: benchmark these funcs
local this_file = debug.getinfo(1, 'S').source:sub(2)
local this_dir = vim.fs.dirname(vim.fs.normalize(this_file))
local topmod = vim.fn.substitute(this_dir, '.*/lua/', '', '')

local files = vim.api.nvim_get_runtime_file(('lua/plug/*.lua'), true)
-- local files = vim.api.nvim_get_runtime_file(('lua/plug/**/*.lua'), true)
-- local files = vim.fn.globpath(vim.fn.stdpath('config'), 'lua/plug/*', false, true)
-- local files = vim.fs.dir(vim.fn.stdpath('config'))


-- TODO:vim.loader 

for _, f in ipairs(files) do
  local mod = vim.fn.fnamemodify(f, ':r:s?^.*/lua/??')
  if mod ~= 'plug/init' then
    print(mod)
else
  print('skipping ' .. mod .. '...')
  end
end

