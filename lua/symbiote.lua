local M = {}

vim.pack.add(vim.tbl_map(function(p) return ('https://github.com/%s.git'):format(p) end, {
  -- https://www.npmjs.com/package/@github/copilot-language-server
  -- TODO: copilot.vim comes with copilot-language-server
  -- otherwise download with mason
  -- 'github/copilot.vim',
  'folke/sidekick.nvim',
}))

M.tab = function()
  if vim.fn.pumvisible() ~= 0 then
    return '<C-y>'
  end

  if package.loaded['blink.cmp'] and require('blink.cmp').select_and_accept() then
    return
  end

  -- if there is a next edit, jump to it, otherwise apply it if any
  if package.loaded['sidekick'] and require('sidekick').nes_jump_or_apply() then
    return -- jumped or applied
  end

  if vim.lsp.inline_completion.get() then
    return
  end

  return '<Tab>' -- fallback
end

M.symbiosis = function()
  -- if not vim.api.nvim_get_runtime_file('lua/lspconfig/lsp/copilot', false)[1] then
  --   vim.notify('lspconfig for copilot not found', vim.log.levels.WARN)
  -- end
  vim.lsp.config('copilot', { root_dir = vim.fn.expand('~/GitHub') })
  vim.lsp.enable('copilot')
  vim.lsp.inline_completion.enable()

  -- setup `supertab`
  vim.keymap.set(
    { 'n', 'i' },
    '<Tab>',
    M.tab,
    { expr = true, desc = 'vim-symbiote <Tab> completion' }
  )

  if not Snacks then
    return
  end
  Snacks.toggle
    .new({
      name = 'Inline Completion',
      get = function() return vim.lsp.inline_completion.is_enabled() end,
      set = function(state) vim.lsp.inline_completion.enable(state) end,
    })
    :map('<leader>ai')
  Snacks.toggle
    .new({
      name = 'Sidekick NES',
      get = function() return require('sidekick.nes').enabled end,
      set = function(state) require('sidekick.nes').enable(state) end,
    })
    :map('<leader>an')
end

return M
