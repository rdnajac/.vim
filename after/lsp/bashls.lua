---@type vim.lsp.Config
return {
  ---@type lspconfig.settings.bashls
  settings = {
    bashIde = {
      shfmt = {
        binaryNextLine = true,
        caseIndent = false,
        funcNextLine = false,
        keepPadding = true,
        languageDialect = 'posix',
        simplifyCode = true,
        spaceRedirects = true,
      },
    },
  },
}
