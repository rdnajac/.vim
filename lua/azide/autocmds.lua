
-- HACK: don't close oil floating window
vim.api.nvim_create_autocmd('BufWinEnter', {
  group = ooze_group,
  pattern = 'oil://*',
  callback = function()
    for _, ac in ipairs(vim.api.nvim_get_autocmds({ group = 'Oil', event = 'WinLeave' })) do
      if ac.desc == 'Close floating oil window' then
        vim.api.nvim_del_autocmd(ac.id)
      end
    end
  end,
})

-- vim.api.nvim_create_autocmd('WinClosed', {
--   group = ooze_group,
--   callback = function(args)
--     if tonumber(args.match) == oil_win then
--       oil_win = nil
--       if stub_win and vim.api.nvim_win_is_valid(stub_win) then
--         vim.api.nvim_win_close(stub_win, true)
--         stub_win = nil
--       end
--     end
--   end,
-- })
--
-- vim.api.nvim_create_autocmd('BufEnter', {
--   callback = function(args)
--     if tonumber(args.buf) == stub_buf then
--       if oil_win and vim.api.nvim_win_is_valid(oil_win) then
--         vim.defer_fn(function()
--           vim.api.nvim_set_current_win(oil_win)
--         end, 0)
--       end
--     end
--   end,
-- })
