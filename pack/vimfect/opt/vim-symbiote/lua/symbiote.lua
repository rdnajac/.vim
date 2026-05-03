local M = {}

vim.pack.add(vim.tbl_map(function(p) return ('https://github.com/%s.git'):format(p) end, {
  -- https://www.npmjs.com/package/@github/copilot-language-server
  -- TODO: copilot.vim comes with copilot-language-server
  -- otherwise download with mason
  -- 'github/copilot.vim',
  'folke/sidekick.nvim',
}))

M.symbiosis = function()
  -- if not vim.api.nvim_get_runtime_file('lua/lspconfig/lsp/copilot', false)[1] then
  --   vim.notify('lspconfig for copilot not found', vim.log.levels.WARN)
  -- end
  vim.lsp.config('copilot', { root_dir = vim.fn.expand('~/GitHub') })
  vim.lsp.enable('copilot')
  vim.lsp.inline_completion.enable()

  vim.keymap.set('i', '<Tab>', function()
    if not vim.lsp.inline_completion.get() then
      return '<Tab>'
    end
  end, { expr = true, desc = 'Accept the current inline completion' })

  vim.keymap.set('n', '<Tab>', function()
    -- if there is a next edit, jump to it, otherwise apply it if any
    if not require('sidekick').nes_jump_or_apply() then
      return '<Tab>' -- fallback to normal tab
    end
  end, { expr = true, desc = 'Goto/Apply Next Edit Suggestion' })


  if Snacks then
    Snacks.toggle
      .new({
        name = 'Sidekick NES',
        get = function() return require('sidekick.nes').enabled end,
        set = function(state) require('sidekick.nes').enable(state) end,
      })
      :map('yoN')
  end
end

return M
