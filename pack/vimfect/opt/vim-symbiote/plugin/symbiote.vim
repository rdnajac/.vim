if exists('g:loaded_symbiote')
  finish
endif
let g:loaded_symbiote = 1

if exists('g:force_copilot')
  nnoremap <leader>ap <Cmd>lua require('sidekick.cli').prompt({ name = 'copilot' })<CR>
  inoremap <leader>at <Cmd>lua require('sidekick.cli').send({ name = 'copilot', msg = '{file}' })<CR>
  xnoremap <leader>at <Cmd>lua require('sidekick.cli').send({ name = 'copilot', msg = '{this}' })<CR>
  lua vim.keymap.set({'n','t','i','x'}, '<C-.>', function() require('sidekick.cli').focus('copilot') end, {})
else
  nnoremap <leader>ap <Cmd>lua require('sidekick.cli').prompt()<CR>
  inoremap <leader>at <Cmd>lua require('sidekick.cli').send({msg='{file}'})<CR>
  xnoremap <leader>at <Cmd>lua require('sidekick.cli').send({msg='{this}'})<CR>
  lua vim.keymap.set({'n','t','i','x'}, '<C-.>', function() require('sidekick.cli').focus() end, {})
endif

lua vim.schedule(require('symbiote').symbiosis)
