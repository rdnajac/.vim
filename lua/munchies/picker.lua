---@module "snacks"

local M = {
  ---@type snacks.picker.debug
  debug = {
    -- scores = true,
    -- leaks = true,
    -- explorer = true,
    -- files = true,
    -- grep = true,
    -- proc = true,
    -- extmarks = true,
  },
  layouts = {
    mylayout = {
      preset = 'ivy',
      reverse = true,
      ---@type snacks.layout.Box[]
      layout = {
        box = 'vertical',
        row = vim.o.lines - math.floor(0.4 * vim.o.lines),
        height = 0.4,
        {
          box = 'horizontal',
          border = 'rounded',
          {
            win = 'list',
            title = ' {title} {live} {flags}',
            title_pos = 'left',
            -- border = borders.toppad,
          },
          {
            win = 'preview',
            title = '{preview:Preview}',
            title_pos = 'left',
            -- border = borders.toppad,
            width = 0.6,
            wo = { number = false },
            -- todo: hide preview window if less than 120 cols
          },
        },
        {
          win = 'input',
          height = 1,
          -- border = nv.ui.border(left, borders.right),
        },
      },
    },
    -- pup-up for selecting text in insert mode
    insert = {
      layout = {
        reverse = true,
        relative = 'cursor',
        row = 1,
        width = 0.3,
        min_width = 48,
        height = 0.3,
        border = 'none',
        box = 'vertical',
        { win = 'input', height = 1, border = 'rounded', wo = { cursorline = false } },
        { win = 'list', border = 'rounded' },
      },
    },
  },
}


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

  if require('nvim.util').is_nonempty_list(opts.ft) then
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
local default_config = {
  actions = {
    clear = function(self)
      ---@diagnostic disable-next-line: inject-field
      self.opts.ft = nil
      self:refresh()
    end,

    inspect_opts = function(self) Snacks.debug.inspect(self.opts) end,

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
        ['<M-d>'] = { 'inspect_opts', mode = { 'i', 'n' } },
      },
    },
  },
}

M.sources = {
  -- autocmds = { confirm =  },
  buffers = {
    layout = 'mylayout',
    input = { keys = { ['<C-x>'] = { 'bufdelete', mode = { 'n', 'i' } } } },
  },
  explorer = require('nvim.fs.explorer'),
  files = default_config,
  grep = default_config,
  -- git_status = { layout = 'left' },
  keymaps = {
    ---@param p snacks.Picker
    ---@param item snacks.picker.Item
    confirm = function(p, item)
      if not nv.is_nonempty_string(item.file) then
        local info = vim.fn.getscriptinfo({ sid = item.item.sid })
        item.file = info and info[1] and info[1].name
        item.pos = { item.item.lnum, 0 }
      end
      p:action({ 'jump' })
    end,
  },
  help = { layout = 'mylayout' },
  icons = { layout = 'insert' },
  recent = { config = function(p) p.filter = {} end },
  zoxide = { confirm = 'edit' },
  -- mine!
  cheatsheets = {
    finder = 'files',
    cwd = vim.fn.stdpath('config') .. '/doc',
    layout = { preset = 'insert' },
    confirm = function(p, item)
      p:close()
      Snacks.zen({ win = { file = item._path } })
    end,
  },
  todo = require('nvim.util.todo').snacks_picker_opts,
}

vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = 'snacks_picker_preview',
  callback = function(ev)
    if MiniHipatterns then
      MiniHipatterns.enable(ev.buf)
    end
  end,
})

return M
-- vim: fdl=0
