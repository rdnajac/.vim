-- https://www.npmjs.com/package/@github/copilot-language-server
local info = {
  name = 'Neovim',
  version = tostring(vim.version()),
}

---@type vim.lsp.Config
return {
  init_options = {
    editorInfo = info,
    editorPluginInfo = info,
  },
  settings = {
    telemetry = {
      telemetryLevel = 'all', -- TODO:do i want this?
    },
  },
}
