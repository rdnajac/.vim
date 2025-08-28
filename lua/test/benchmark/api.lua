local files = vim.api.nvim_get_runtime_file(('lua/plug/*.lua'), true)

for _, v in ipairs(files) do
  print(v)
end
