--- to add a new action:
--- 1. local function
--- 2. assign to new action
--- 3. set input window keymap

-- TODO: rename this file
-- TODO: add cd function using vim.input

---@param self snacks.Picker
local function _restore(self)
  local resume = require('snacks.picker.resume')
  local state = resume.state[self.opts.source]
  if not state then
    -- FIXME:
    return Snacks.notify.warn('No resume state found for ' .. self.opts.source)
  end
  self.list:set_selected(state.selected)
  self.list:update()
  self.input:update()
  self.matcher.task:on(
    'done',
    vim.schedule_wrap(function()
      if self.closed then
        return
      end
      self.list:view(state.cursor, state.topline)
    end)
  )
end

-- table of string names mapped to a function that takes snacks.Picker as param
---@type table<string, fun(self: snacks.Picker)>
local actions = {
  clear = function(self)
    ---@cast self.opts.ft string|string[]|nil
    self.opts.ft = nil
    self:refresh()
  end,

  debugp = function(self)
    Snacks.debug.inspect(self.opts)
  end,

  gitroot = function(self)
    self:set_cwd(Snacks.git.get_root())
    self:refresh()
  end,

  toggle = function(self)
    local resume = require('snacks.picker.resume')
    resume.add(self)
    self:close()
    local ret = Snacks.picker.pick({
      source = self.opts.source == 'grep' and 'files' or 'grep',
      cwd = self:cwd(),
      -- pattern = state.filter.pattern,
      -- search = state.filter.search,
    })
    _restore(ret)
  end,

  zoxide = function(picker)
    local resume = require('snacks.picker.resume')
    resume.add(picker)
    picker:close()

    Snacks.picker.zoxide({
      confirm = function(z, item)
        resume.state[picker.opts.source].opts.cwd = item.file
        z:close()
      end,
      layout = 'mylayout',
      on_close = function()
        Snacks.picker.resume()
      end,
    })
  end,
}

---@param opts snacks.picker.files.Config
---@return string
local function title(opts)
  local icon_map = { grep = '󰱽', files = '' }
  local icon = icon_map[opts.finder] or ' '
  local name = opts.finder:sub(1, 1):upper() .. opts.finder:sub(2)
  local searchpath = (opts.dirs and (#opts.dirs == 1 and opts.dirs[1] or 'Multiple Paths'))
    -- or vim.fn.fnamemodify(opts.cwd, ':~')
    or opts.cwd

  local ret = string.format('%s %s [ %s ]', icon, name, searchpath)
  if vim.islist(opts.ft) and #opts.ft > 0 then
    ret = table.concat(
      vim.list_extend(
        { ret },
        vim.tbl_map(function(ft)
          return nv.icons.filetype[ft]
        end, opts.ft)
      ),
      ' '
    )
  end
  return ret
end

---@type snacks.picker.Config
return {
  actions = actions,
  ---@param opts snacks.picker.files.Config
  config = function(opts)
    opts.cwd = opts.cwd or Snacks.git.get_root() or vim.fn.getcwd()
    opts.layout = { preset = 'mylayout' }
    -- hide the preview window if the screen is too narrow
    if vim.o.columns < 100 or opts.finder == 'grep' then
      opts.layout.auto_hide = { 'preview' }
    end
    opts.title = title(opts)
    return opts
  end,
  win = {
    input = {
      keys = {
        ['`'] = { 'toggle', mode = { 'i', 'n' } },
        ['~'] = { 'zoxide', mode = { 'i', 'n' } },
        ['<M-c>'] = { 'clear', mode = { 'i', 'n' } },
        ['<M-d>'] = { 'debug', mode = { 'i', 'n' } },
      },
    },
  },
}
