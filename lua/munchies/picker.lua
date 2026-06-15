---@type snacks.picker.Config
local M = {
  -- db = { sqlite3_path = nil } -- TODO:
  debug = {
    -- scores = true,
    -- leaks = true,
    -- explorer = true,
    -- files = true,
    -- grep = true,
    -- proc = true,
    -- extmarks = true,
  },
  prompt = ' ',
  sort = { fields = { 'score:desc', '#text', 'idx' } },
  ---@class snacks.picker.previewers.Config
  previewers = {
    diff = {
      style = 'fancy', ---@type "fancy"|"syntax"|"terminal"
      cmd = { 'delta' },
      -- wo = {},
    },
  },
}

local function title(self)
  local picker = self.source
  local icon = nv.ui.icons._picker_source[picker] or ''
  local name = picker and picker:sub(1, 1):upper() .. picker:sub(2)
  local dir = self.dirs and #self.dirs .. ' paths'
  or vim.fn.pathshorten(vim.fn.fnamemodify(self.cwd or vim.fn.getcwd(), ':~'), 2)
  local extra = ''
  if self.ft then -- add filetype icons if filtering by filetype
    local ftlist = type(self.ft) == 'table' and self.ft or { self.ft }
    extra = extra
    .. vim
    .iter(ftlist)
    :map(function(ft) return MiniIcons.get('filetype', ft) or '?' end)
    :join('  ')
  end
  return string.format('%s %s [%s] %s', icon, name, dir, extra)
end

M.actions = {
  -- clear = require('munchies.filter').clear,
  -- filter = require('munchies.filter').filter,
  inspect_self = function(self) Snacks.debug.inspect(self) end,
  inspect_opts = function(self) Snacks.debug.inspect(self.opts) end,
  set_title = function(self) self.title = title(self) end,
}

--- every picker gets passed to this config function before rendering
--- intercept pickers by source and set options
---
M.config = function(self)
  if self.source == 'explorer' then
    --- unhide directories under `/chezmoi/`
    ---@cast self snacks.picker.explorer.Config
    self = require('snacks.picker.source.explorer').setup(self)
    self.hidden = self.cwd and self.cwd:match('%/chezmoi') or false
  elseif vim.tbl_contains({ 'files', 'grep', 'buffers' }, self.source) then
    -- pass layout directly to picker config instead of setting it up
    self.layout = require('munchies').mylayout
    self.cwd = self.cwd or Snacks.git.get_root()
  end
  if not vim.tbl_contains({ 'select' }, self.source) then
    M.actions.set_title(self)
  end
  -- hide the preview window if the screen is too narrow
  -- self.layout.auto_hide = vim.o.columns < 100 and { 'preview' } or opts.layout.auto_hide
  return self
end

M.actions.toggle = function(self)
  local resume = require('snacks.picker.resume')
  resume.add(self)
  local source = self.opts.source
  local state = resume.state[source]
  local opts = {
    source = source == 'files' and 'grep' or 'files',
    cwd = self:cwd(),
    pattern = state.filter.pattern,
    search = state.filter.search,
  }
  self:close()
  local ret = Snacks.picker.pick(opts)
  ret.list:set_selected(state.selected)
  ret.list:update()
  ret.matcher.task:on(
    'done',
    vim.schedule_wrap(function()
      if ret.closed then
	return
      end
      ret.list:view(state.cursor, state.topline)
    end)
  )
end

-- change picker directory using zoxide and resume
M.actions.zoxide = function(self)
  local resume = require('snacks.picker.resume')
  self.on_close = function()
    resume.add(self)
    Snacks.picker.zoxide({
      confirm = function(z, item)
	resume.state[self.opts.source].opts.cwd = item.file
	z:close()
      end,
      layout = 'ivy',
      on_close = function() resume.resume() end,
    })
  end
  self:close()
end

M.sources = {
  explorer = require('munchies.explorer'),
  highlights = {
    --- enable mini.hipatterns in the preview buffer
    --- @param picker snacks.Picker
    on_show = function(picker)
      if MiniHipatterns then
	MiniHipatterns.enable(picker.preview.win.buf)
	-- Snacks.util.redraw(picker.preview.win.win)
      end
    end,
  },
  keymaps = {
    --- make confirm work with keymaps defined in vimscripts
    --- @param picker snacks.Picker
    --- @param item snacks.picker.Item
    confirm = function(picker, item)
      if not item.file then
	local info = vim.fn.getscriptinfo({ sid = item.item.sid })
	item.file = info and info[1] and info[1].name
	item.pos = { item.item.lnum, 0 }
      end
      picker:action({ 'jump' })
    end,
  },
  -- don't try to resume the picker picker
  resume = { exclude = 'pickers' },
  -- edit the directory instead of loading the session
  zoxide = { confirm = 'jump' },
}

return M
