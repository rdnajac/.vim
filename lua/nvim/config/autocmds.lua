local aug = vim.api.nvim_create_augroup('munchies', { clear = true })

-- Nvim will always call a Lua function with a single table containing information
-- about the triggered autocommand. The most useful keys are
-- • `match`: a string that matched the `pattern` (see |<amatch>|)
-- • `buf`:   the number of the buffer the event was triggered in (see |<abuf>|)
-- • `file`:  the file name of the buffer the event was triggered in (see |<afile>|)
-- • `data`:  a table with other relevant data that is passed for some events

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'lua',
  group = aug,
  callback = function()
    Snacks.util.set_hl({ LspReferenceText = { link = 'NONE' } })
  end,
  desc = 'Disable LSP reference highlight in Lua files',
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'help', 'man', 'qf', 'nvim-pack' },
  group = aug,
  callback = function(ev)
    if Snacks.util.is_transparent() then
      Snacks.util.wo(0, { winhighlight = Snacks.util.winhl('Normal:SpecialWindow') })
    end
    -- vim.bo[ev.buf].buflisted = false
    vim.keymap.set('n', 'q', '<Cmd>lclose<CR><C-W>q', { buffer = true })
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'man' },
  group = aug,
  callback = function(ev)
    vim.bo[ev.buf].buflisted = false
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

-- -- BUG: this still interferes with extui
-- vim.api.nvim_create_autocmd('User', {
--   pattern = 'SnacksDashboardOpened',
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
