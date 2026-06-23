local M = {}
--- see `:h ui-messages` and require('vim/_core/ui2').cfg
---@type table<string,  nil|'cmd'|'msg'|'pager'>
M.targets = {
  -- default = 'msg',
  ['confirm'] = 'cmd',
  ['emsg'] = 'cmd',
  ['echo'] = 'msg',
  ['echomsg'] = 'msg',
  ['echoerr'] = 'msg',
  ['completion'] = nil,
  ['list_cmd'] = 'pager',
  ['lua_error'] = 'cmd',
  ['lua_print'] = 'msg',
  ['rpc_error'] = nil,
  ['progress'] = 'cmd',
  ['quickfix'] = nil,
  ['search_cmd'] = 'cmd',
  ['search_count'] = 'cmd',
  ['shell_cmd'] = nil,
  ['shell_err'] = nil,
  ['shell_out'] = nil,
  ['shell_ret'] = nil,
  ['undo'] = 'cmd',
  ['verbose'] = nil,
  ['wildlist'] = nil,
  ['wmsg'] = 'cmd',
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
  ui2.msg.set_pos = function(target)
    orig_set_pos(target)
    if target and target ~= 'msg' then
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

--- adds milliseconds to the timestamp and adds a border below the title
---@type snacks.notifier.render
M.style = function(buf, n, ctx)
  -- set up a buffer starting with two empty lines followed by the message
  local lines = vim.list_extend({ '', '' }, vim.split(n.msg, '\n'))
  local title = (n.title or ''):gsub('Debug: lua:0', vim.fn.histget('cmd', -1))
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_extmark(buf, ctx.ns, 0, 0, {
    virt_text = { { n.icon, ctx.hl.icon }, { ' ' }, { title, ctx.hl.title } },
    virt_text_win_col = 1,
    priority = 10,
  })
  vim.api.nvim_buf_set_extmark(buf, ctx.ns, 0, 0, {
    virt_text = {
      { ('[%s] '):format(require('nvim').now(n.added)), ctx.hl.title },
    },
    virt_text_pos = 'right_align',
    priority = 10,
  })
  -- add a border below the title
  vim.api.nvim_buf_set_extmark(buf, ctx.ns, 1, 0, {
    virt_text = { { string.rep('━', vim.wo.columns - 2), ctx.hl.border } },
    virt_text_win_col = 0,
    priority = 10,
  })
end

M.test = function()
  for _, kind in ipairs({ 'error', 'warn', 'info', 'notify' }) do
    Snacks.notify[kind]('This is a message')
  end
end

return M
