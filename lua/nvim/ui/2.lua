--- `:h ui2`
local ui2 = require('vim._core.ui2')

--- `:h ui-messages`
---@type table<string, nil|'cmd'|'msg'|'pager'>
local targets = {
  [''] = nil,
  ['empty'] = nil,
  ['bufwrite'] = nil,
  ['confirm'] = nil,
  ['emsg'] = nil,
  ['echo'] = nil,
  ['echomsg'] = nil,
  ['echoerr'] = nil,
  ['completion'] = nil,
  ['list_cmd'] = nil,
  ['lua_error'] = nil,
  ['lua_print'] = nil,
  ['progress'] = nil,
  ['rpc_error'] = nil,
  ['quickfix'] = nil,
  ['search_cmd'] = nil,
  ['search_count'] = nil,
  ['shell_cmd'] = nil,
  ['shell_err'] = nil,
  ['shell_out'] = nil,
  ['shell_ret'] = nil,
  ['undo'] = nil,
  ['verbose'] = nil,
  ['wildlist'] = nil,
  ['wmsg'] = nil,
}

ui2.enable({
  msg = {
    target = 'msg',
    -- targets = targets,
  },
})

local msg = ui2.msg
local last_msg_kind

local original_msg_show = msg.msg_show
msg.msg_show = function(kind, ...)
  last_msg_kind = kind
  return original_msg_show(kind, ...)
end

local original_set_pos = msg.set_pos
msg.set_pos = function(tgt)
  original_set_pos(tgt)
  if tgt and tgt ~= 'msg' then
    return
  end

  local win = ui2.wins.msg
  if not vim.api.nvim_win_is_valid(win) then
    return
  end

  local cfg = vim.api.nvim_win_get_config(win)
  if cfg.hide then
    return
  end
  cfg.title = { { (' %s '):format(last_msg_kind), 'FloatTitle' } }
  cfg.title_pos = 'left'
  vim.api.nvim_win_set_config(win, cfg)
end

local ui_fts = { 'msg', 'pager' }
vim.treesitter.language.register('markdown', ui_fts)
vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = ui_fts,
  callback = function(ev)
    vim.treesitter.start(0)
    vim.wo.conceallevel = 3
    vim.keymap.set({ 'n' }, 'gf', require('nvim.fs').better_gf, { buf = ev.buf })
    -- vim.wo.winbar = 'winbar'
  end,
  desc = 'Apply markdown tree-sitter highlighting for message windows',
})
