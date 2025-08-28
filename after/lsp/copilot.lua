-- https://www.npmjs.com/package/@github/copilot-language-server
---@type vim.lsp.Config
return {
  cmd = {
    'copilot-language-server',
    '--stdio',
  },
  root_markers = { '.git' },
  init_options = {
    editorInfo = {
      name = 'Neovim',
      version = tostring(vim.version()),
    },
    editorPluginInfo = {
      name = 'Neovim',
      version = tostring(vim.version()),
    },
  },
  settings = {
    telemetry = {
      telemetryLevel = 'all',
    },
  },
}
