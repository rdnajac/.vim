---@type vim.lsp.Config
return {
  cmd = { 'shuck', 'server' },
  filetypes = { 'sh' },
  root_markers = { '.shuck.toml', 'shuck.toml', '.git' },
}
