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

au('FileType', { 'help', 'man', 'qf' }, function(ev)
  vim.bo[ev.buf].buflisted = false
  vim.schedule(function()
    -- `q` to quit from normal mode
    vim.keymap.set('n', 'q', function()
      vim.cmd('close')
      pcall(vim.api.nvim_buf_delete, ev.buf, { force = true })
    end, { buffer = ev.buf, silent = true, desc = 'Quit buffer' })
  end)
end)

vim.api.nvim_create_autocmd('BufNewFile', {
  pattern = 'after/lsp/*.lua',
  command = '0r ' .. vim.fn.stdpath('config') .. '/templates/lsp.lua',
  group = aug,
})

vim.api.nvim_create_autocmd('CmdlineEnter', {
  group = aug,
  callback = function()
    vim.b.lastlaststatus = vim.o.laststatus
    vim.o.laststatus = 0
  end,
})

vim.api.nvim_create_autocmd('CmdlineLeave', {
  group = aug,
  callback = function()
    vim.o.laststatus = vim.b.lastlaststatus or 2
  end,
})
