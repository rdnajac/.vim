local aug = vim.api.nvim_create_augroup('munchies', { clear = true })

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'help', 'man', 'qf', 'nvim-pack' },
  group = aug,
  callback = function(ev)
    if Snacks.util.is_transparent() then
      Snacks.util.wo(0, { winhighlight = { Normal = 'SpecialWindow' } })
    end
    vim.bo[ev.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set('n', 'q', function()
        vim.cmd('close')
        -- TODO: use snacks bufdelete
        pcall(vim.api.nvim_buf_delete, ev.buf, { force = true })
      end, { buffer = ev.buf, silent = true, desc = 'Quit buffer' })
    end)
  end,
})
--
-- vim.api.nvim_create_autocmd('FileType', {
--   pattern = 'snacks_dashboard',
--   group = aug,
--   callback = function()
--     local old_winborder = vim.o.winborder
--     if old_winborder ~= 'none' then
--       vim.o.winborder = 'none'
--       vim.schedule(function()
--         vim.opt.lazyredraw = true
--         Snacks.dashboard.update()
--         vim.opt.lazyredraw = false
--         vim.o.winborder = old_winborder
--       end)
--     end
--   end,
-- })

-- BUG: this still interferes with extui
vim.api.nvim_create_autocmd('User', {
  pattern = 'SnacksDashboardOpened',
  callback = function()
    local old_winborder = vim.o.winborder
    if old_winborder ~= 'none' then
      vim.o.winborder = 'none'
      vim.schedule(function()
        vim.opt.lazyredraw = true
        Snacks.dashboard.update()
        vim.opt.lazyredraw = false
        vim.o.winborder = old_winborder
      end)
    end
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'lua',
  group = aug,
  callback = function()
    Snacks.util.set_hl({ LspReferenceText = { link = 'NONE' } })
  end,
  desc = 'Disable LSP reference highlight in Lua files',
})
