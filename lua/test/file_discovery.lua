local this_file = debug.getinfo(1, 'S').source:sub(2)
local this_dir = vim.fs.dirname(vim.fs.normalize(this_file))
local topmod = vim.fn.substitute(this_dir, '.*/lua/', '', '')
local runtime_files = vim.api.nvim_get_runtime_file('lua/plug/**/*.lua', true)
local config_files = vim.fn.globpath(vim.fn.stdpath('config'), 'lua/plug/*', false, true)
local config_files_iter = vim.fs.dir(vim.fn.stdpath('config'))
local modules = vim.loader.find('*', { all = true })

-- return vim.fn.fnamemodify(path, ':r:s?^.*/lua/??')

local dir = vim.fs.joinpath(vim.fn.stdpath('config'), 'lua', 'nvim')
local iter = vim.iter(vim.fs.dir(dir))
for name in iter do
  print('nvim.' .. name:match('^(%a*).*$'))
end
