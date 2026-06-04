if !has('nvim')
  let g:copilot_no_tab_map = v:true
  imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
  finish
endif

" imap <silent><script><expr> <C-J> luaeval('vim.lsp.inline_completion.get()') ? '' : '<Tab>'
nmap <silent> <Tab> <Plug>(symbiote-tab)

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

augroup symbiote
  autocmd!
  autocmd BufEnter term://*:R\ * startinsert
  autocmd BufEnter term://*/copilot startinsert
augroup END
