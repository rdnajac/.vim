-- TODO: add cd function using vim.input

---@param opts snacks.picker.files.Config
---@return string
local function title(opts)
  local icon = ({ grep = '󰱽', files = '' })[opts.finder] or ' '
  local name = opts.finder:sub(1, 1):upper() .. opts.finder:sub(2)
  local searchpath = opts.cwd
  if opts.dirs then
    searchpath = #opts.dirs == 1 and opts.dirs[1] or 'Multiple Paths'
  end
  local parts = { icon, name, '[' .. searchpath .. ']' }

  if nv.is_nonempty_list(opts.ft) then
    ---@diagnostic disable-next-line: param-type-mismatch
    vim.list_extend(parts, vim.tbl_map(nv.ui.icons.filetype, opts.ft))
  end

  return table.concat(parts, ' ')
end

--- to add a new action:
--- 1. local function
--- 2. assign to new action
--- 3. set input window keymap

---@type snacks.picker.Config
return {
  actions = {
    clear = function(self)
      ---@diagnostic disable-next-line: inject-field
      self.opts.ft = nil
      self:refresh()
    end,

    debugp = function(self) Snacks.debug.inspect(self.opts) end,

    gitroot = function(self)
      self:set_cwd(Snacks.git.get_root())
      self:refresh()
    end,

    toggle = function(self)
      local resume = require('snacks.picker.resume')
      resume.add(self)
      local source = self.opts.source
      local state = resume.state[source]
      local new_source = source == 'files' and 'grep' or 'files'
      local opts = {
        source = new_source,
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
    end,

    zoxide = function(self)
      local resume = require('snacks.picker.resume')
      resume.add(self)
      self:close()
      Snacks.picker.zoxide({
        confirm = function(z, item)
          resume.state[self.opts.source].opts.cwd = item.file
          z:close()
        end,
        layout = 'mylayout',
        on_close = function() Snacks.picker.resume() end,
      })
    end,

    sidekick_send = function(...)
      -- name = 'copilot'
      return require('sidekick.cli.picker.snacks').send(...)
    end,
  },

  ---@param opts snacks.picker.files.Config
  config = function(opts)
    opts.cwd = opts.cwd or Snacks.git.get_root() or vim.fn.getcwd()
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
        ['<M-a>'] = { 'sidekick_send', mode = { 'n', 'i' } },
        ['<M-c>'] = { 'clear', mode = { 'i', 'n' } },
        ['<M-d>'] = { 'debug', mode = { 'i', 'n' } },
      },
    },
  },
}
