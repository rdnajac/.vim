--- `:h ui2`
local ui2 = require('vim._core.ui2')
local ui_fts = { 'msg', 'pager' }

vim.treesitter.language.register('markdown', ui_fts)

vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = ui_fts,
  callback = function(ev)
    vim.treesitter.start(0)
    vim.wo.conceallevel = 3
    vim.keymap.set({ 'n' }, 'gf', require('nvim.util').better_gf, { buf = ev.buf })
    -- vim.wo.winbar = 'winbar'
  end,
  desc = 'Apply markdown tree-sitter highlighting for message windows',
})

--- see `:h ui-messages` for a complete list
---@type table<string, nil|'cmd'|'msg'|'pager'>
local kinds = {
  [''] = nil,
  ['empty'] = nil,
  ['confirm'] = nil,
  ['emsg'] = nil,
  ['echo'] = nil,
  ['echomsg'] = nil,
  ['echoerr'] = nil,
  ['completion'] = nil,
  ['list_cmd'] = nil,
  ['lua_error'] = nil,
  -- ['lua_print'] = 'pager',
  ['rpc_error'] = nil,
  ['progress'] = nil,
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

-- require('vim._core.ui2').enable({ msg = { targets = 'msg' } })
ui2.enable({ msg = { targets = vim.tbl_extend('error', { default = 'msg' }, kinds) } })

local msg = ui2.msg
local last_msg_kind

local orig_msg_show = msg.msg_show
msg.msg_show = function(kind, ...)
  last_msg_kind = kind
  return orig_msg_show(kind, ...)
end

local orig_set_pos = msg.set_pos
msg.set_pos = function(tgt)
  orig_set_pos(tgt)
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
