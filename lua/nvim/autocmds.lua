local aug = vim.api.nvim_create_augroup('user', { clear = true })

---@param ev string|string[]
---@param pattern string|string[]
---@param act function|string  -- string => :command, function => callback
---@param desc? string
local function au(ev, pattern, act, desc)
  local opts = { group = aug, pattern = pattern, desc = desc }
  if type(act) == 'string' then
    opts.command = act
  else
    opts.callback = act
  end
  return vim.api.nvim_create_autocmd(ev, opts)
end

au('TextYankPost', '*', function()
  vim.highlight.on_yank()
end)

au('FileType', { 'help', 'man', 'qf' }, function(ev)
  if Snacks.util.is_transparent() then
    Snacks.util.wo(0, { winhighlight = { Normal = 'SpecialWindow' } })
  end
  vim.bo[ev.buf].buflisted = false
  vim.schedule(function()
    -- `q` to quit from normal mode
    vim.keymap.set('n', 'q', function()
      vim.cmd('close')
      pcall(vim.api.nvim_buf_delete, ev.buf, { force = true })
    end, { buffer = ev.buf, silent = true, desc = 'Quit buffer' })
  end)
  desc = 'Ephemeral buffers'
end)

au('FileType', 'lua', function()
  Snacks.util.set_hl({ LspReferenceText = { link = 'NONE' } })
end)

au('BufNewFile', 'after/lsp/*.lua', function()
  local template = vim.fn.stdpath('config') .. '/templates/lsp.lua'
  if vim.fn.filereadable(template) == 1 then
    vim.cmd('0r ' .. template)
  end
end, 'Insert LSP template on new file')

-- TODO: move to vimline
vim.api.nvim_create_autocmd('CmdlineEnter', {
  group = aug,
  callback = function()
    vim.b.lastlaststatus = vim.o.laststatus
    vim.o.laststatus = 0
  end,
})

vim.api.nvim_create_autocmd('CmdlineLeave', {
  group = aug,
  callback = function()
    vim.o.laststatus = vim.b.lastlaststatus or 2
  end,
})
