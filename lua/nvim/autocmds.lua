local group = vim.api.nvim_create_augroup('my_autocmds', { clear = true })

--- @param event string|string[]
--- @param pattern string|string[]
--- @param callback function
--- @param desc? string
local au = function(event, pattern, callback, desc)
  vim.api.nvim_create_autocmd(event, { group = group, pattern = pattern, callback = callback })
end

local db = function(ev)
  print(string.format('event fired: %s', vim.inspect(ev)))
end

-- vim.api.nvim_create_autocmd('BufEnter', {
--   callback = function(ev)
--     audebug(ev)
--   end,
-- })

au('TextYankPost', '*', function()
  vim.hl.on_yank()
end)

au('FileType', { 'lua', 'vim' }, function()
  -- vim.opt.formatoptions:remove({ 'c' })
  vim.opt.formatoptions:remove({ 'r', 'o' })
end)

au('FileType', { 'help', 'man', 'qf', 'query' }, function(ev)
  vim.bo[ev.buf].buflisted = false
  vim.schedule(function()
    vim.keymap.set('n', 'q', function()
      vim.cmd('close')
      pcall(vim.api.nvim_buf_delete, ev.buf, { force = true })
    end, {
      buffer = ev.buf,
      silent = true,
      desc = 'Quit buffer',
    })
  end)
end)

au('FileType', { 'kitty', 'ghostty' }, function(event)
  if require('nvim-treesitter.parsers').has_parser('bash') then
    vim.treesitter.language.register('bash', event.match)
    vim.treesitter.start(0, 'bash')
  end
end, 'Use bash parser for kitty and ghostty configs')

au('FileType', { 'help', 'man' }, function()
  if Snacks.util.is_transparent() then
    vim.cmd([[setlocal winhighlight=Normal:SpecialWindow]])
  end
end)

-- Show relative numbers only when they matter (linewise and blockwise
-- selection) and 'number' is set (avoids horizontal flickering)
au('ModeChanged', '*:[V\x16]*', function()
  vim.wo.relativenumber = vim.wo.number
end, 'Show relative line numbers')

-- Hide relative numbers when neither linewise/blockwise mode is on
au('ModeChanged', '[V\x16]*:*', function()
  vim.wo.relativenumber = string.find(vim.fn.mode(), '^[V\22]') ~= nil
end, 'Hide relative line numbers')

local ooze_group = vim.api.nvim_create_augroup('ooze', { clear = true })

vim.api.nvim_create_autocmd('TermOpen', {
  group = ooze_group,
  callback = function(args)
    -- args.buf contains the buffer that triggered the autocmd
    if vim.bo[args.buf].filetype == 'snacks_terminal' then
      vim.g.ooze_channel = vim.bo[args.buf].channel
      vim.g.ooze_buffer = vim.api.nvim_get_current_buf()
      vim.g.ooze_send_on_enter = 1
    end
  end,
  desc = 'Capture the job ID (`channel`) of a newly opened Snacks terminal',
})

vim.api.nvim_create_autocmd('User', {
  group = ooze_group,
  pattern = 'OilActionsPost',
  callback = function(ev)
    if ev.data.actions.type == 'move' then
      Snacks.rename.on_rename_file(ev.data.actions.src_url, ev.data.actions.dest_url)
    end
  end,
  desc = 'Snacks rename on Oil move',
})

vim.api.nvim_create_autocmd('User', {
  group = ooze_group,
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
  group = ooze_group,
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
  group = ooze_group,
  pattern = 'oil://*',
  callback = function()
    vim.cmd.lcd(vim.fn.getcwd(-1, -1))
  end,
  desc = 'Restore lcd to CWD on leaving Oil buffer',
})
