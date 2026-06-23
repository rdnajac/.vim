-- _G.dd = Snacks.debug
-- _G.bt = dd.backtrace
--- @module "Snacks"
--- @type snacks.picker.Config
local picker = require('munchies.picker')
picker.layouts = require('munchies.layouts')
-- picker.db = { sqlite3_path = nil } -- TODO:
picker.debug = {
  -- scores = true,
  -- leaks = true,
  -- explorer = true,
  -- files = true,
  -- grep = true,
  -- proc = true,
  -- extmarks = true,
}
picker.prompt = ' '
-- picker.sort = { fields = { 'score:desc', '#text', 'idx' } }

---@class snacks.picker.previewers.Config
picker.previewers = {
  diff = {
    style = 'fancy', ---@type "fancy"|"syntax"|"terminal"
    cmd = { 'delta' },
    -- wo = {},
  },
}

local sidekick_send = { ['<M-a>'] = { 'sidekick_send', mode = { 'n', 'i' } } }
picker.win = {
  input = { keys = sidekick_send },
  list = { keys = sidekick_send },
}

local function title(self)
  local source = self.source
  local icon = nv.ui.icons._picker_source[source] or ''
  local name = source and source:sub(1, 1):upper() .. source:sub(2)
  local dir = self.dirs and #self.dirs .. ' paths'
    or vim.fn.pathshorten(vim.fn.fnamemodify(self.cwd or vim.fn.getcwd(), ':~'), 2)
  local extra = ''
  if self.ft then -- add filetype icons if filtering by filetype
    local ftlist = type(self.ft) == 'table' and self.ft or { self.ft }
    extra = extra
      .. vim
        .iter(ftlist)
        :map(function(ft)
          return MiniIcons.get('filetype', ft) or '?'
        end)
        :join('  ')
  end
  return string.format('%s %s [%s] %s', icon, name, dir, extra)
end


--- common config for some pickers
picker.config = function(self)
  if vim.tbl_contains({ 'files', 'grep', 'buffers' }, self.source) then
    -- pass layout directly to picker config instead of setting it up
    -- self.layout = require('munchies').mylayout
    self.layout = 'mylayout'
    self.cwd = self.cwd or Snacks.git.get_root()
  end
  if not vim.tbl_contains({ 'select' }, self.source) then
    self.title = title(self)
  end
  -- hide the preview window if the screen is too narrow
  -- self.layout.auto_hide = vim.o.columns < 100 and { 'preview' } or opts.layout.auto_hide
  return self
end

--- @type snacks.Config
return {
  picker = picker,
  -- statuscolumn = require('munchies.statuscolumn'),
}
