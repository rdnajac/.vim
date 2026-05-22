vim.lsp.config('copilot', { root_dir = vim.fn.expand('~/GitHub') })
vim.lsp.enable('copilot')
vim.lsp.inline_completion.enable()

Plug('folke/sidekick.nvim')

local tab = function()
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

vim.keymap.set({ 'n', 'i' }, '<Tab>', tab, { expr = true, desc = 'vim-symbiote <Tab> completion' })

if Snacks then
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

vim.cmd([[
let g:force_copilot = 1
if exists('g:force_copilot')
  nnoremap <leader>ap <Cmd>lua require('sidekick.cli').prompt({ name = 'copilot' })<CR>
  nnoremap <leader>at <Cmd>lua require('sidekick.cli').send({ name = 'copilot', msg = '{file}' })<CR>
  xnoremap <leader>at <Cmd>lua require('sidekick.cli').send({ name = 'copilot', msg = '{this}' })<CR>
  lua vim.keymap.set({'n','t','i','x'}, '<C-.>', function() require('sidekick.cli').focus('copilot') end, {})
else
  nnoremap <leader>ap <Cmd>lua require('sidekick.cli').prompt()<CR>
  nnoremap <leader>at <Cmd>lua require('sidekick.cli').send({msg='{file}'})<CR>
  xnoremap <leader>at <Cmd>lua require('sidekick.cli').send({msg='{this}'})<CR>
  lua vim.keymap.set({'n','t','i','x'}, '<C-.>', function() require('sidekick.cli').focus() end, {})
endif
]])
