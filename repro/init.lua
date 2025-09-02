local root = vim.fn.fnamemodify('./.repro', ':p')

for _, name in ipairs({ 'config', 'data', 'state', 'cache' }) do
  vim.env[('XDG_%s_HOME'):format(name:upper())] = root .. '/' .. name
end

local files = vim.loader.find('*', { all = true })

vim.print(vim.inspect(files))
