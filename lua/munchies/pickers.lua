---@param opts snacks.picker.files.Config
---@return string
local function title(opts)
  local finder = opts.finder or opts.source or 'files'
  local icon = ({ explorer = '󰙅', files = '', grep = '󰱽' })[finder] or ''
  local name = finder:sub(1, 1):upper() .. finder:sub(2)
  local cwd = vim.fn.fnamemodify(opts.cwd or vim.fn.getcwd(), ':~')

  if opts.dirs then
    cwd = #opts.dirs == 1 and opts.dirs[1] or 'Multiple Paths'
  elseif finder == 'explorer' then
    cwd = vim.fn.pathshorten(cwd)
  end

  local ret = string.format('%s %s [%s]%s', icon, name, cwd, ' ')
  if opts.ft then
    local ft_icons = vim
      .iter(type(opts.ft) == 'table' and opts.ft or { opts.ft })
      :map(function(ft)
        local rv = nv.ui.icons.filetype[ft]
        return rv
      end)
      :join('  ')
    ret = ret .. ' ' .. ft_icons
  end
  return ret
end

---@type snacks.picker.files.Config
local common_config = {
  actions = {
    ---@param self snacks.picker.files.Config
    clear = function(self)
      self.opts.ft = nil
      self:refresh()
    end,
    dir = function(self)
      -- TODO: change the cwd and resume picking...
    end,
    ---@param self snacks.picker.files.Config
    filter_ft = function(self)
      vim.ui.input({
        prompt = 'Filter by filetype (comma separated for multiple)',
      }, function(input)
        if input and input ~= '' then
          self.opts.ft = vim.split(input, '%A+', { trimempty = true })
          self.title = title(self.opts)
          self:refresh()
        end
      end)
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
        layout = 'ivy',
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
    -- pass layout directly to picker config instead of setting it up
    opts.layout = require('munchies.layouts').mylayout
    -- if opts.source == 'files' or opts.source == 'grep' then
    opts.cwd = opts.cwd or Snacks.git.get_root() or vim.fn.getcwd()
    -- hide the preview window if the screen is too narrow
    if vim.o.columns < 100 then
      opts.layout.auto_hide = { 'preview' }
    end
    opts.title = title(opts)
    return opts
  end,
  win = {
    input = {
      keys = {
        -- ['`'] = { 'toggle', mode = { 'i', 'n' } },
        -- ['~'] = { 'zoxide', mode = { 'i', 'n' } },
        ['<M-a>'] = { 'sidekick_send', mode = { 'i', 'n' } },
        ['<M-c>'] = { 'clear', mode = { 'i', 'n' } },
        ['<M-d>'] = { function(self) Snacks.debug.inspect(self.opts) end, mode = { 'i', 'n' } },
        ['<M-e>'] = { 'filter_ft', mode = { 'i', 'n' } },
      },
    },
  },
}

return {
  explorer = {
    ignored = true, -- always show git ignored files
    jump = { close = true }, -- close buffer after selecting a file
    config = function(opts) -- override default config function
      local explorer = require('snacks.picker.source.explorer').setup(opts)
      -- show hidden files inside chezmoi source dir
      explorer.hidden = explorer.cwd:match('%/chezmoi') ~= nil
      explorer.title = title(explorer) -- reuse the title function
      return explorer
    end,
    win = {
      list = {
        keys = {
          ['/'] = 'picker_grep',
          ['-'] = 'explorer_up',
          ['<Left>'] = 'explorer_up',
          ['<Right>'] = 'confirm',
        },
      },
      preview = { border = 'rounded', focusable = false },
    },
    on_show = require('munchies.explorer').on_show,
  },
  files = common_config,
  grep = common_config,
  highlights = {
    --- enable mini.hipatterns in the preview buffer
    ---@param picker snacks.Picker
    on_show = function(picker)
      if MiniHipatterns then
        MiniHipatterns.enable(picker.preview.win.buf)
        -- Snacks.util.redraw(picker.preview.win.win)
      end
    end,
  },
  keymaps = {
    --- make confirm work with keymaps defined in vimscripts
    ---@param picker snacks.Picker
    ---@param item snacks.picker.Item
    confirm = function(picker, item)
      if not item.file then
        local info = vim.fn.getscriptinfo({ sid = item.item.sid })
        item.file = info and info[1] and info[1].name
        item.pos = { item.item.lnum, 0 }
      end
      picker:action({ 'jump' })
    end,
  },
}
