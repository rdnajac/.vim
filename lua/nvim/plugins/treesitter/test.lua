
print(vim.api.nvim_get_runtime_file("parser/*", true))
for _, path in ipairs(vim.api.nvim_get_runtime_file("parser/*", true)) do
  print(path)

for lang, parser in pairs(vim.treesitter.language.require_language) do
  print(lang, vim.inspect(parser))
end

for lang, parser in pairs(vim.treesitter.language.require_language) do
  print(lang, vim.inspect(parser))
end
