print('au')
local aug = function(aug)
  vim.api.nvim_create_augroup('nvim_' .. aug, { clear = true })
end

local audebug = function(ev)
  print(string.format('event fired: %s', vim.inspect(ev)))
end

vim.api.nvim_create_autocmd('TextYankPost', {
  group = aug('highlight_yank'),
  callback = function()
    (vim.hl or vim.highlight).on_yank()
  end,
  desc = 'Highlight on yank',
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

vim.api.nvim_create_autocmd('FileType', {
  group = aug('close_with_q'),
  pattern = {
    'checkhealth',
    'help',
    'man',
    'qf',
    'tsplayground',
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set('n', 'q', function()
        vim.cmd('close')
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, {
        buffer = event.buf,
        silent = true,
        desc = 'Quit buffer',
      })
    end)
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('kitty', { clear = true }),
  pattern = 'kitty',
  callback = function()
    if require('nvim-treesitter.parsers').has_parser('bash') then
      vim.treesitter.language.register('bash', 'kitty')
      vim.treesitter.start(0, 'bash')
    end
  end,
  desc = 'Use bash parser for kitty config',
})

vim.api.nvim_create_autocmd('TermOpen', {
  group = aug('ooze'),
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

vim.api.nvim_create_autocmd('FileType', {
  group = aug('winhl'),
  pattern = { 'man', 'help' },
  callback = function()
    if Snacks.util.is_transparent() then
      vim.cmd([[setlocal winhighlight=Normal:SpecialWindow]])
      -- TODO: configure window
    end
  end,
  desc = 'Set a bg color for certain filetypes',
})

-- Snacks.util.on_module('oil', function()
vim.api.nvim_create_autocmd('User', {
  pattern = 'OilActionsPost',
  callback = function(event)
    if event.data.actions.type == 'move' then
      Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
    end
  end,
  desc = 'Snacks rename on Oil move',
})

vim.api.nvim_create_autocmd('User', {
  pattern = 'OilActionsPre',
  callback = function(event)
    -- TODO: is this loop necessary?
    for _, action in ipairs(event.data.actions) do
      if action.type == 'delete' then
        local _, path = require('oil.util').parse_url(action.url)
        Snacks.bufdelete({ file = path, force = true })
      end
    end
  end,
  desc = 'Delete buffer on Oil delete',
})
-- end)
