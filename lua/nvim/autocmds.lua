local aug = vim.api.nvim_create_augroup('nvimrc', { clear = true })

local au = function(ev, pattern, cb)
  vim.api.nvim_create_autocmd(ev, {
    pattern = pattern,
    group = aug,
    callback = cb,
  })
end

au('TextYankPost', '*', function()
  vim.highlight.on_yank()
end)

au('FileType', { 'lua' }, function()
  vim.cmd([[call fold#text()]]) -- HACK: this is not automatically loaded in nvim
  Snacks.util.set_hl({ LspReferenceText = { link = 'NONE' } })
end)

au('FileType', { 'help', 'man', 'qf' }, function(ev)
  vim.bo[ev.buf].buflisted = false
  vim.schedule(function()
    -- `q` to quit from normal mode
    vim.keymap.set('n', 'q', function()
      vim.cmd('close')
      pcall(vim.api.nvim_buf_delete, ev.buf, { force = true })
    end, { buffer = ev.buf, silent = true, desc = 'Quit buffer' })
    -- highlight the windows a different color
    if Snacks.util.is_transparent() then
      Snacks.util.wo(0, { winhighlight = { Normal = 'SpecialWindow' } })
    end
    -- vim.cmd('wincmd L')
  end)
end)

au('FileType', { 'kitty', 'ghostty' }, function(ev)
  vim.treesitter.language.register('bash', ev.match)
  vim.treesitter.start(0, 'bash')
  vim.cmd('setlocal commentstring=#%s')
end)

vim.api.nvim_create_autocmd('BufNewFile', {
  pattern = 'after/lsp/*.lua',
  command = '0r ' .. vim.fn.stdpath('config') .. '/templates/lsp.lua',
  group = aug,
})

vim.api.nvim_create_autocmd('CmdlineEnter', {
  command = 'set laststatus=0',
  group = aug,
})

vim.api.nvim_create_autocmd('CmdlineLeave', {
  command = 'set laststatus=3',
  group = aug,
})
