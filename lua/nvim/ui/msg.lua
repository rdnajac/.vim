local ui_fts = { 'msg', 'pager' }
nv.on('FileType', ui_fts, function(ev)
  vim.cmd([[setl cole=3 winhl=@markup.strikethrough:NONE]])
  vim.keymap.set('n', { 'gf', '<2-RightMouse>' }, nv.goto_file, { buf = ev.buf, expr = true })
  vim.treesitter.start(ev.buf) -- TODO: instead, selectively start the parser at the notify level
end)
nv.on('VimEnter', '*', vim.treesitter.language.register('markdown', ui_fts))

local M = {}

--- see `:h ui-messages`
---@type table<string,  nil|'cmd'|'msg'|'pager'>
M.targets = {
  default = 'msg',
  [''] = nil,
  ['empty'] = nil,
  ['bufwrite'] = 'cmd',
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

M.setup = function()
  local ui2 = require('vim._core.ui2')
  local last_msg_kind
  local orig_msg_show = ui2.msg.msg_show
  ui2.msg.msg_show = function(kind, ...)
    last_msg_kind = kind
    return orig_msg_show(kind, ...)
  end
  local orig_set_pos = ui2.msg.set_pos
  ui2.msg.set_pos = function(tgt)
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
end

M.opts = { -- require('vim/_core/ui2').cfg
  -- $VIMRUNTIME/lua/vim/_core/ui2.lua:60
  msg = {
    -- cmd = { height = 0.5, },
    -- dialog = { height = 0.5, },
    -- pager = { height = 0.999, },
    -- msg = { height = 0.5, timeout = 4000, },
    targets = M.targets,
  },
}

return M
