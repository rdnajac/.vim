local group = vim.api.nvim_create_augroup('my_autocmds', { clear = true })

--- @param event string|string[]
--- @param pattern string|string[]
--- @param callback function
--- @param desc? string
local au = function(event, pattern, callback, desc)
  local opts = { group = group, pattern = pattern, callback = callback }

  if desc then
    opts.desc = desc
  end
  vim.api.nvim_create_autocmd(event, opts)
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

au('FileType', { 'checkhealth', 'help', 'man', 'qf', 'tsplayground' }, function(ev)
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

au('FileType', { 'help', 'man', 'oil' }, function()
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

vim.api.nvim_create_autocmd('TermOpen', {
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

-- Snacks.util.on_module('oil', function()
vim.api.nvim_create_autocmd('User', {
  pattern = 'OilActionsPost',
  callback = function(ev)
    if ev.data.actions.type == 'move' then
      Snacks.rename.on_rename_file(ev.data.actions.src_url, ev.data.actions.dest_url)
    end
  end,
  desc = 'Snacks rename on Oil move',
})

vim.api.nvim_create_autocmd('User', {
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
  pattern = 'oil://*',
  callback = function()
    vim.cmd.lcd(vim.fn.getcwd(-1, -1))
  end,
  desc = 'Restore lcd to CWD on leaving Oil buffer',
})

local cmd_group = vim.api.nvim_create_augroup('cmdline', { clear = true })
vim.api.nvim_create_autocmd('CmdlineEnter', {
  group = cmd_group,
  callback = function(args)
    if vim.bo[args.buf].filetype ~= 'snacks_dashboard' then
      vim.api.nvim_create_autocmd('CmdlineLeave', {
        once = true,
        callback = function()
          vim.o.laststatus = 3
        end,
      })
      vim.o.laststatus = 0
    end
  end,
})

vim.api.nvim_create_autocmd('CmdlineEnter', {
  group = cmd_group,
  command = 'set laststatus=0',
})

-- vim.api.nvim_create_autocmd('FileType', {
--   pattern = { 'man' },
--   callback = function(event)
--     vim.bo[event.buf].buflisted = false
--   end,
-- })
