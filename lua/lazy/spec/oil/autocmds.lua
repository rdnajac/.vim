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

vim.api.nvim_create_autocmd('BufEnter', {
  group = myoilautocmds,
  pattern = 'oil://*',
  callback = function(args)
    local oil = require('oil')
    local dir = oil.get_current_dir(args.buf)
    if dir and vim.fn.isdirectory(dir) == 1 then
      vim.cmd.lcd(dir)
    end
  end,
  desc = 'Sync lcd with Oil directory on buffer enter',
})

vim.api.nvim_create_autocmd('BufLeave', {
  group = myoilautocmds,
  pattern = 'oil://*',
  callback = function()
    vim.cmd.lcd(vim.fn.getcwd(-1, -1))
  end,
  desc = 'Restore lcd to CWD on leaving Oil buffer',
})
