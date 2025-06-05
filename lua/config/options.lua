-- § settings {{{
vim.opt.backup = true
vim.opt.backupdir = vim.fn.stdpath('state') .. '/backup//'
vim.opt.clipboard = vim.env.SSH_TTY and '' or 'unnamedplus'
-- vim.opt.foldexpr = "v:lua.require'lazyvim.util'.ui.foldexpr()"
vim.opt.foldexpr = 'v:lua.LazyVim.ui.foldexpr()'
vim.opt.foldtext = ''
vim.opt.foldmethod = 'expr'
vim.opt.foldlevel = 99
-- vim.opt.formatexpr = "v:lua.require'lazyvim.util'.format.formatexpr()"
vim.opt.mousescroll = 'hor:0'
vim.opt.pumblend = 0
vim.opt.signcolumn = 'yes'
vim.opt.smoothscroll = true
vim.opt.winborder = 'rounded'
-- }}}
-- § diagnostics {{{
  local icons = LazyVim.config.icons
vim.diagnostic.config({
  underline = false,
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
      [vim.diagnostic.severity.WARN]  = icons.diagnostics.Warn,
      [vim.diagnostic.severity.HINT]  = icons.diagnostics.Hint,
      [vim.diagnostic.severity.INFO]  = icons.diagnostics.Info,
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = 'DiagnosticError',
      [vim.diagnostic.severity.WARN] = 'DiagnosticWarn',
      [vim.diagnostic.severity.INFO] = 'DiagnosticInfo',
      [vim.diagnostic.severity.HINT] = 'DiagnosticHint',
    },
  },
})
--- }}}
-- § extui {{{
if vim.fn.has('nvim-0.12') == 1 then
  vim.opt.cmdheight = 0
  require('vim._extui').enable({
    msg = {
      pos = 'box',
      box = { timeout = 2000 },
    },
  })
end
--- }}}
-- § lsp {{{
-- Refer to :h vim.lsp.config() for more information.
vim.lsp.config('*', {
  -- capabilities = require('blink.cmp').get_lsp_capabilities(),
  -- capabilities = require('blink.cmp').get_lsp_capabilities(nil, true),

  ---@param client vim.lsp.Client
  ---@param bufnr integer
  on_attach = function(client, bufnr)
    local opts = { buffer = bufnr }

    if client:supports_method('textDocument/inlayHint') then
      vim.lsp.inlay_hint.enable(true, opts)
    end

    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
-- TODO: ensure only map to buffer
-- stylua: ignore
    require('which-key').add({

      { 'grr', function() Snacks.picker.lsp_references() end, nowait = true, desc = 'References', },
      { 'gd', function() Snacks.picker.lsp_definitions() end, desc = 'Goto Definition', },
      { 'gD', function() Snacks.picker.lsp_declarations() end, desc = 'Goto Declaration', },
      { 'gI', function() Snacks.picker.lsp_implementations() end, desc = 'Goto Implementation', },
      { 'gy', function() Snacks.picker.lsp_type_definitions() end, desc = 'Goto T[y]pe Definition', },
      { 'grs', function() Snacks.picker.lsp_symbols() end, desc = 'LSP Symbols', },
      { 'grw', function() Snacks.picker.lsp_workspace_symbols() end, desc = 'LSP Workspace Symbols', },
    })

    if client:supports_method('textDocument/codeLens') then
      vim.lsp.codelens.refresh()
      vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
        buffer = bufnr,
        callback = vim.lsp.codelens.refresh,
      })

      client.server_capabilities.documentFormattingProvider = false
      print('LSP attached: ' .. client.name)
    end
  end,
})
--- }}}
-- vim: fdm=marker fdl=0
