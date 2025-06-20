-- vim: fdl=1
local M = {}

M.setup = function()
  M.options()
  M.diagnostic()
  M.lsp()
  M.ui()
end

M.options = function()
  vim.opt.backup = true
  vim.opt.backupdir = vim.fn.stdpath('state') .. '/backup//'
  vim.opt.clipboard = vim.env.SSH_TTY and '' or 'unnamedplus'
  vim.opt.cmdheight = 0
  -- vim.opt.formatexpr = "v:lua.require'lazyvim.util'.format.formatexpr()"
  vim.opt.mousescroll = 'hor:0'
  vim.opt.pumblend = 0
  vim.opt.signcolumn = 'yes'
  vim.opt.smoothscroll = true
  vim.opt.winborder = 'rounded'
  vim.opt.jumpoptions = 'view,stack'

  -- HACK: don't show lualine on dashboard
  if vim.fn.argc(-1) == 0 and vim.bo.filetype == 'snacks_dashboard' then
    vim.opt.laststatus = 0
  end
end

local icons = LazyVim.config.icons
M.diagnostic = function()
  vim.diagnostic.config({
    underline = false,
    severity_sort = true,
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = icons.diagnostics.error,
        [vim.diagnostic.severity.WARN] = icons.diagnostics.warn,
        [vim.diagnostic.severity.HINT] = icons.diagnostics.hint,
        [vim.diagnostic.severity.INFO] = icons.diagnostics.info,
      },
      numhl = {
        [vim.diagnostic.severity.ERROR] = 'DiagnosticError',
        [vim.diagnostic.severity.WARN] = 'DiagnosticWarn',
        [vim.diagnostic.severity.INFO] = 'DiagnosticInfo',
        [vim.diagnostic.severity.HINT] = 'DiagnosticHint',
      },
    },
  })
end

M.lsp = function()
  -- Refer to `:h vim.lsp.config()` for more information.
  vim.lsp.config('*', {
    capabilities = require('blink.cmp').get_lsp_capabilities(),

    ---@param client vim.lsp.Client
    ---@param bufnr integer
    on_attach = function(client, bufnr)
      if client:supports_method('textDocument/documentSymbol') then
        require('nvim.util.navic').attach(client, bufnr)
      end

      if client:supports_method('textDocument/inlayHint') then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        Snacks.toggle.inlay_hints():map('<leader>uh')
      end

      if client:supports_method('textDocument/codeLens') then
        vim.lsp.codelens.refresh()
        vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
          buffer = bufnr,
          callback = vim.lsp.codelens.refresh,
        })

        client.server_capabilities.documentFormattingProvider = false

        vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr })

    -- stylua: ignore
    require('which-key').add({
      icon = { icon = ' ', color = 'orange' },
      { 'gO' },
      { 'gr', group = 'LSP' },
      { 'grr', function() Snacks.picker.lsp_references() end, desc = 'References', buffer = bufnr, nowait = true, },
      { 'gd',  function() Snacks.picker.lsp_definitions() end,       desc = 'Goto Definition', buffer = bufnr },
      { 'gD',  function() Snacks.picker.lsp_declarations() end,      desc = 'Goto Declaration', buffer = bufnr },
      { 'gI',  function() Snacks.picker.lsp_implementations() end,   desc = 'Goto Implementation', buffer = bufnr },
      { 'gy',  function() Snacks.picker.lsp_type_definitions() end,  desc = 'Goto T[y]pe Definition', buffer = bufnr },
      { 'grs', function() Snacks.picker.lsp_symbols() end,           desc = 'LSP Symbols', buffer = bufnr },
      { 'grw', function() Snacks.picker.lsp_workspace_symbols() end, desc = 'LSP Workspace Symbols', buffer = bufnr },
    })
      end
    end,
  })
  vim.lsp.enable(_G.lang_spec.lsps)
end

M.ui = function()
  -- XXX: experimental!
  if vim.fn.has('nvim-0.12') == 1 then
    require('vim._extui').enable({
      -- msg = {
      --   target = 'cmd',
      --   timeout = 4000,
      -- },
    })
  end

  if not LazyVim.has('lualine') then
    local cmd_group = vim.api.nvim_create_augroup('cmdline', { clear = true })
    vim.api.nvim_create_autocmd('CmdlineEnter', {
      group = cmd_group,
      callback = function(args)
        if vim.bo[args.buf].filetype ~= 'snacks_dashboard' then
          vim.api.nvim_create_autocmd('CmdlineLeave', {
            once = true,
            callback = function()
              vim.o.laststatus = 3
            end,
          })
          vim.o.laststatus = 0
        end
      end,
    })
    vim.api.nvim_create_autocmd('CmdlineEnter', {
      group = cmd_group,
      command = 'set laststatus=0',
    })
  end
end

return M
