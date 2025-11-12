-- FIXME: doesn't work
---@param self snacks.Picker
local function clear(self)
  self.opts.ft = nil
  self.list:update()
end

---@param self snacks.Picker
local function restore(self)
  local resume = require('snacks.picker.resume')
  local state = resume.state[self.opts.source]
  if not state then
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

---@param picker snacks.Picker
local toggle = function(picker)
  local resume = require('snacks.picker.resume')
  resume.add(picker)
  picker:close()
  local ret = Snacks.picker.pick({
    source = picker.opts.source == 'grep' and 'files' or 'grep',
    cwd = picker:cwd(),
    -- pattern = state.filter.pattern,
    -- search = state.filter.search,
  })
  restore(ret)
end

---@param picker snacks.Picker
local zoxide = function(picker)
  local resume = require('snacks.picker.resume')
  resume.add(picker)
  picker:close()

  Snacks.picker.zoxide({
    confirm = function(z, item)
      resume.state[picker.opts.source].opts.cwd = item.file
      z:close()
    end,
    on_close = function()
      Snacks.picker.resume()
    end,
  })
end

---@type snacks.picker.Config
return {
  ---@param opts snacks.picker.Config
  config = function(opts)
    opts.layout = { preset = 'mydefault' }
    local icon_map = { grep = '󰱽', files = '' }
    local icon = icon_map[opts.finder] or ' '
    local name = opts.finder:sub(1, 1):upper() .. opts.finder:sub(2)
    local searchpath = opts.dirs and 'Multiple Paths' or vim.fn.fnamemodify(opts.cwd, ':~')

    opts.title = string.format('%s %s [ %s ]', icon, name, searchpath)
    if vim.islist(opts.ft) and #opts.ft > 0 then
      opts.title = table.concat(
        vim.list_extend(
          { opts.title },
          vim.tbl_map(function(ft)
            return nv.icons.filetype[ft]
          end, opts.ft)
        ),
        ' '
      )
    end

    if not opts.cwd then
      opts.cwd = Snacks.git.get_root() or vim.fn.getcwd()
    end

    -- hide the preview window if the screen is too narrow
    if vim.o.columns < 100 or opts.finder == 'grep' then
      opts.layout.auto_hide = { 'preview' }
    end

    return opts
  end,
  actions = {
    clear = clear,
    toggle = toggle,
    zoxide = zoxide,
  },
  win = {
    input = {
      keys = {
        ['`'] = { 'toggle', mode = { 'i', 'n' } },
        ['~'] = { 'zoxide', mode = { 'i', 'n' } },
        ['P'] = {
          function(p)
            Snacks.debug.inspect(p.opts)
          end,
          mode = { 'n' },
        },
        ['<M-c>'] = { 'clear', mode = { 'i', 'n' } },
      },
    },
  },
}
