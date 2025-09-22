local aug = vim.api.nvim_create_augroup('myoil', {})

vim.api.nvim_create_autocmd('BufEnter', {
  pattern = 'oil://*',
  group = aug,
  callback = function()
    require('oil.actions').cd.callback({ silent = true })
  end,
  desc = 'Sync cd with Oil directory on buffer enter',
})

-- these require snacks to be loaded.

vim.api.nvim_create_autocmd('User', {
  pattern = 'OilActionsPost',
  group = aug,
  callback = function(ev)
    if ev.data.actions.type == 'move' then
      Snacks.rename.on_rename_file(ev.data.actions.src_url, ev.data.actions.dest_url)
    end
  end,
  desc = 'Snacks rename on Oil move',
})

vim.api.nvim_create_autocmd('User', {
  pattern = 'OilActionsPre',
  group = aug,
  callback = function(ev)
    for _, action in ipairs(ev.data.actions) do
      if action.type == 'delete' then
        local _, path = require('oil.util').parse_url(action.url)
        Snacks.bufdelete({ file = path, force = true })
        -- vim.cmd.edit(vim.fn.fnamemodify(path, ':h'))
      end
    end
  end,
  desc = 'Delete buffer on Oil delete',
})
