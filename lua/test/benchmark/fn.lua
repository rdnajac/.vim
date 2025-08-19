-- finds all top-level items in the lua/plug directory
local specs = vim.fn.globpath(vim.fn.stdpath('config'), 'lua/plug/*', false, true)
for _, f in ipairs(specs) do
  local mod = vim.fn.fnamemodify(f, ':r:s?^.*/lua/??')
  print(mod)
  if mod ~= 'plug/init' then
    print(mod)
  end
end
