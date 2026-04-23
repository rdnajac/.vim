vim.pack.add(vim.tbl_map(function(p) return ('https://github.com/%s.git'):format(p) end, {
  -- 'github/copilot.vim',
  'folke/sidekick.nvim',
}))
-- https://www.npmjs.com/package/@github/copilot-language-server
-- TODO: copilot.vim comes with copilot-language-server
-- otherwise download with mason


vim.schedule(function()
  vim.lsp.config('copilot', { root_dir = vim.fn.expand('~/GitHub') })
  vim.lsp.enable('copilot')
  vim.lsp.inline_completion.enable()
end)

-- if not vim.api.nvim_get_runtime_file('lua/lspconfig/lsp/copilot', false)[1] then
--   vim.notify('lspconfig for copilot not found', vim.log.levels.WARN)
-- end

if Snacks then
  Snacks.toggle
    .new({
      name = 'Sidekick NES',
      get = function() return require('sidekick.nes').enabled end,
      set = function(state) require('sidekick.nes').enable(state) end,
    })
    :map('yoN')
end

