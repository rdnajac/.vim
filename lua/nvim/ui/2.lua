--- see `:h ui-messages` for a complete list
---@type table<string, nil|'cmd'|'msg'|'pager'>
local kinds = {
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

-- local msg = ui2.msg
-- local last_msg_kind
-- local orig_msg_show = msg.msg_show
-- msg.msg_show = function(kind, ...)
--   last_msg_kind = kind
--   return orig_msg_show(kind, ...)
-- end
-- local orig_set_pos = msg.set_pos
-- msg.set_pos = function(tgt)
--   orig_set_pos(tgt)
--   if tgt and tgt ~= 'msg' then
--     return
--   end
--   local win = ui2.wins.msg
--   if not vim.api.nvim_win_is_valid(win) then
--     return
--   end
--   local cfg = vim.api.nvim_win_get_config(win)
--   if cfg.hide then
--     return
--   end
--   cfg.title = { { (' %s '):format(last_msg_kind), 'FloatTitle' } }
--   cfg.title_pos = 'left'
--   vim.api.nvim_win_set_config(win, cfg)
-- end

local opts = { msg = { targets = 'msg' } }

--- handles truncated paths in the debug.traceback like `.../path/to/file:line:`
--- @param cfile? string defaults to `expand('<cfile>')`
local goto_file = function(cfile)
  cfile = cfile or vim.fn.expand('<cfile>')
  if vim.startswith(cfile, '...') then
    -- HACK: the errors are probably from one of these two dirs
    for dir, pattern in pairs({ PACKDIR = '/core/opt/', VIMRUNTIME = '/nvim/runtime/' }) do
      local match = cfile:match('.*' .. pattern .. '(.*)')
      if match and match ~= '' then
        local file = vim.fs.joinpath(vim.env[dir], match)
        if file and vim.uv.fs_stat(file) then
          return ('<Cmd>wincmd w| call edit#goto("%s")'):format(cfile)
          -- vim.cmd('close')
          -- fn['edit#goto'](file)
          -- return
        end
      end
    end
  end
  return 'gf'
  -- vim.cmd('normal! gf')
end

return {
  setup = function()
    local ui_fts = { 'msg', 'pager' }
    vim.treesitter.language.register('markdown', ui_fts)
    nv.on('FileType', ui_fts, function(ev)
      vim.treesitter.start(ev.buf)
      vim.wo.conceallevel = 3
      -- vim.keymap.set('n', { 'gf', '<2-LeftMouse>' }, goto_file, { buf = ev.buf, expr = true })
      vim.keymap.set('n', { 'gf', '<2-LeftMouse>' }, '<C-W><C-F>', { buf = ev.buf })
    end)
    require('vim._core.ui2').enable(opts)
    -- HACK: markdown highlighting does too much outside code blocks
    vim.cmd([[au Colorscheme * hi clear @markup.strikethrough]])
  end,
}
