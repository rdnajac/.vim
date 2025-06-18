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
  vim.treesitter.language.register('bash', event.match)
  vim.treesitter.start(0, 'bash')
  vim.cmd('setlocal commentstring=#%s')
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

-- Auto-insert LSP template for new files in ~/.config/nvim/lsp/*.lua
au('BufNewFile', 'lsp/*.lua', function()
  local template = vim.fn.stdpath('config') .. '/templates/lsp.lua'
  if vim.fn.filereadable(template) == 1 then
    vim.cmd('0r ' .. template)
  end
end, 'Insert LSP template')

-- TODO: move this
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
