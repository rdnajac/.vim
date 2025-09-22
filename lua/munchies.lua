print('snack attack!')
---@class Snacks: snacks.plugins
local M = {}

setmetatable(M, {
  __index = function(t, k)
    t[k] = require('snacks.' .. k)
    return rawget(t, k)
  end,
})

_G.svim = vim

M.config = vim.tbl_deep_extend('force', require('config'), nv.snacks.opts)

local events = {
  BufReadPre = { 'bigfile', 'image' },
  BufReadPost = { 'quickfile', 'indent' },
  BufEnter = { 'explorer' },
  LspAttach = { 'words' },
  UIEnter = { 'dashboard', 'scroll', 'input', 'scope', 'picker' },
}

---@param event string
---@param ev? vim.api.keyset.create_autocmd.callback_args
local function load(event, ev)
  local todo = events[event] or {}
  events[event] = nil
  for _, snack in ipairs(todo) do
    if M.config[snack] and M.config[snack].enabled then
      if M[snack].setup then
        M[snack].setup(ev)
      elseif M[snack].enable then
        M[snack].enable()
      end
    end
  end
end

local group = vim.api.nvim_create_augroup('snacks', {})
vim.api.nvim_create_autocmd(vim.tbl_keys(events), {
  group = group,
  once = true,
  nested = true,
  callback = function(ev)
    load(ev.event, ev)
  end,
})

vim.api.nvim_create_autocmd('BufReadCmd', {
  once = true,
  pattern = '*.' .. table.concat(M.config.image.formats, ',*.'),
  group = group,
  callback = function(e)
    require('snacks.image').setup(e)
  end,
})

vim.o.statuscolumn = [[%!v:lua.require'snacks.statuscolumn'.get()]]

---@diagnostic disable-next-line: duplicate-set-field
vim.notify = function(msg, level, o)
  vim.notify = Snacks.notifier.notify
  return Snacks.notifier.notify(msg, level, o)
end

M.did_setup = true

return M
