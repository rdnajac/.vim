local myoilautocmds = vim.api.nvim_create_augroup('myoilautocmds', { clear = true })

vim.api.nvim_create_autocmd('User', {
  group = myoilautocmds,
  pattern = 'OilActionsPost',
  callback = function(ev)
    if ev.data.actions.type == 'move' then
      Snacks.rename.on_rename_file(ev.data.actions.src_url, ev.data.actions.dest_url)
    end
  end,
  desc = 'Snacks rename on Oil move',
})

vim.api.nvim_create_autocmd('User', {
  group = myoilautocmds,
  pattern = 'OilActionsPre',
  callback = function(ev)
    -- TODO: is this loop necessary?
    for _, action in ipairs(ev.data.actions) do
      if action.type == 'delete' then
        local _, path = require('oil.util').parse_url(action.url)
        Snacks.bufdelete({ file = path, force = true })
      end
    end
  end,
  desc = 'Delete buffer on Oil delete',
})

-- vim.api.nvim_create_autocmd('User', {
--   group = myoilautocmds,
--   pattern = 'OilEnter',
--   callback = function(ev)
--     local oil = require('oil')
--     if vim.api.nvim_get_current_buf() == ev.data.buf and oil.get_cursor_entry() then
--       vim.defer_fn(function()
--         oil.open_preview(nil, function(err)
--           if not err then
--             vim.cmd.wincmd({ args = { '|' }, count = 30 })
--           end
--         end)
--       end, 0)
--     end
--   end,
-- })
--
vim.api.nvim_create_autocmd('BufEnter', {
  group = myoilautocmds,
  pattern = 'oil://*',
  callback = function()
    require('oil.actions').cd.callback({ silent = true })
  end,
  desc = 'Sync cd with Oil directory on buffer enter',
})
