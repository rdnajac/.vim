local nvimrc = vim.api.nvim_create_augroup('nvimrc', { clear = true })

vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.hl.on_yank()
  end,
  desc = 'Briefly highlight yanked text',
  group = nvimrc,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'lua', 'vim' },
  callback = function()
    -- vim.opt.formatoptions:remove({ 'c' })
    vim.opt.formatoptions:remove({ 'r', 'o' })
    Snacks.util.set_hl({
      LspReferenceText = {},
      -- LspReferenceWrite = {},
    })
  end,
  group = nvimrc,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'help', 'man', 'qf' },
  callback = function(ev)
    vim.bo[ev.buf].buflisted = false
    vim.schedule(function()
      if Snacks.util.is_transparent() then
        Snacks.util.wo(0, { winhighlight = { Normal = 'SpecialWindow' } })
      end
      vim.keymap.set('n', 'q', function()
        vim.cmd('close')
        pcall(vim.api.nvim_buf_delete, ev.buf, { force = true })
      end, { buffer = ev.buf, silent = true })
    end)
  end,
  desc = 'Set options for auxiliary buffers',
  group = nvimrc,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'kitty', 'ghostty' },
  callback = function(event)
    vim.treesitter.language.register('bash', event.match)
    vim.treesitter.start(0, 'bash')
    vim.cmd('setlocal commentstring=#%s')
  end,
  desc = 'Use bash parser for kitty and ghostty configs',
  group = nvimrc,
})

vim.api.nvim_create_autocmd('BufNewFile', {
  pattern = 'after/lsp/*.lua',
  command = '0r ' .. vim.fn.stdpath('config') .. '/templates/lsp.lua',
  desc = 'Insert config template on new lsp file',
  group = nvimrc,
})
