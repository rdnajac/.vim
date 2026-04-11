---@module "snacks"

local M = {}

---@class picker : snacks.picker.Config
---@field ft string|table<string> filetype or list of filetypes to filter by
---@field dirs string[]? list of directories to search

---@param opts picker
---@return string
local function title(opts)
  local picker = opts.source
  local icon = vim.tbl_get(nv, 'ui', 'icons', 'pickers', picker) or ''
  local name = picker and picker:sub(1, 1):upper() .. picker:sub(2)
  local dir = opts.dirs and #opts.dirs .. ' paths'
    or vim.fn.pathshorten(vim.fn.fnamemodify(opts.cwd or vim.fn.getcwd(), ':~'), 2)
  local extra = ''
  -- add filetype icons if filtering by filetype
  if opts.ft then
    local ftlist = type(opts.ft) == 'table' and opts.ft or { opts.ft }
    extra = extra
      .. vim.iter(ftlist):map(function(ft) return nv.ui.icons.filetype[ft] or '?' end):join('  ')
  end
  return string.format('%s %s [%s] %s', icon, name, dir, extra)
end

---@type table<string, fun(snacks.picker.Config):nil>
local actions = {
  set_title = function(self) self.title = title(self.opts or self) end,
  -- clear = require('munchies.filter').clear,
  -- filter = require('munchies.filter').filter,
  toggle = function(self)
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
  end,
  -- change picker directory using zoxide and resume
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
      on_close = function() resume.resume() end,
    })
  end,
  inspect_self = function(self) Snacks.debug.inspect(self) end,
  inspect_opts = function(self) Snacks.debug.inspect(self.opts) end,
}

---@class snacks.picker.Config
M.config = {
  actions = actions,
  ---@param opts snacks.picker.Config
  config = function(opts)
    if opts.source == 'explorer' then
      ---@cast opts snacks.picker.explorer.Config
      opts = require('snacks.picker.source.explorer').setup(opts)
      opts.hidden = opts.cwd and opts.cwd:match('%/chezmoi') or false
      -- add keymaps for navigating the explorer picker
      opts.win.list.keys['/'] = 'picker_grep'
      opts.win.list.keys['-'] = 'explorer_up'
      opts.win.list.keys['<Left>'] = 'explorer_up'
      opts.win.list.keys['<Right>'] = 'confirm'
    else
      -- pass layout directly to picker config instead of setting it up
      opts.layout = require('munchies.layouts').mylayout
      -- if opts.source == 'files' or opts.source == 'grep' then
      opts.cwd = opts.cwd or Snacks.git.get_root()
    end
    -- hide the preview window if the screen is too narrow
    -- opts.layout.auto_hide = vim.o.columns < 100 and { 'preview' } or opts.layout.auto_hide
    actions.set_title(opts)
    return opts
  end,
  sources = {
    explorer = {
      ignored = true, -- always show git ignored files
      jump = { close = true }, -- close buffer after selecting a file
      on_show = require('munchies.explorer').floating_preview,
      win = { preview = { border = 'rounded', focusable = false } },
    },
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
  },
  db = { sqlite3_path = nil },
  prompt = ' ',
  sort = { fields = { 'score:desc', '#text', 'idx' } },
  ---@class snacks.picker.previewers.Config
  previewers = {
    diff = {
      style = 'fancy', ---@type "fancy"|"syntax"|"terminal"
      cmd = { 'delta' },
      ---@type vim.wo?|{} window options for the fancy diff preview window
      wo = {
        breakindent = true,
        wrap = true,
        linebreak = true,
        showbreak = '',
      },
    },
    git = { args = {} },
    file = {
      max_size = 1024 * 1024,
      max_line_length = 500,
      ft = nil, ---@type string? filetype for highlighting. Use `nil` for auto detect
    },
    man_pager = nil, ---@type string? MANPAGER env to use for `man` preview
  },
  ---@class snacks.picker.jump.Config
  jump = {
    jumplist = true,
    tagstack = false,
    reuse_win = false,
    close = true,
    match = false,
  },
  toggles = {
    follow = 'f',
    hidden = 'h',
    ignored = 'i',
    modified = 'm',
    regex = { icon = 'R', value = false },
  },
  win = {
    input = {
      keys = {
        -- ['<c-f>'] = { 'preview_scroll_down', mode = { 'i', 'n' } },
        ['<C-f>'] = { mode = { 'i', 'n' }, 'toggle' },
        ['<M-c>'] = { mode = { 'i', 'n' }, 'clear' },
        ['<M-a>'] = {
          function(picker) return require('sidekick.cli.picker.snacks').send(picker) end,
          mode = { 'i', 'n' },
        },
        ['<M-z>'] = { mode = { 'i', 'n' }, 'zoxide' },
        ['/'] = 'toggle_focus',
        ['<C-c>'] = { 'cancel', mode = 'i' },
        ['<C-w>'] = { '<c-s-w>', mode = { 'i' }, expr = true, desc = 'delete word' },
        ['<CR>'] = { 'confirm', mode = { 'n', 'i' } },
        ['<Esc>'] = 'cancel',
        ['<S-CR>'] = { { 'pick_win', 'jump' }, mode = { 'n', 'i' } },
        ['<S-Tab>'] = { 'select_and_prev', mode = { 'i', 'n' } },
        ['<Tab>'] = { 'select_and_next', mode = { 'i', 'n' } },
        ['<Up>'] = { 'list_up', mode = { 'i', 'n' } },
        ['<Down>'] = { 'list_down', mode = { 'i', 'n' } },
        ['<a-d>'] = { 'inspect', mode = { 'n', 'i' } },
        ['<a-f>'] = { 'toggle_follow', mode = { 'i', 'n' } },
        ['<a-h>'] = { 'toggle_hidden', mode = { 'i', 'n' } },
        ['<a-i>'] = { 'toggle_ignored', mode = { 'i', 'n' } },
        ['<a-m>'] = { 'toggle_maximize', mode = { 'i', 'n' } },
        ['<a-p>'] = { 'toggle_preview', mode = { 'i', 'n' } },
        ['<a-r>'] = { 'toggle_regex', mode = { 'i', 'n' } },
        ['<a-w>'] = { 'cycle_win', mode = { 'i', 'n' } },
        ['<c-a>'] = { 'select_all', mode = { 'n', 'i' } },
        ['<c-j>'] = { 'preview_scroll_up', mode = { 'i', 'n' } },
        ['<c-d>'] = { 'list_scroll_down', mode = { 'i', 'n' } },
        ['<c-g>'] = { 'toggle_live', mode = { 'i', 'n' } },
        ['<c-j>'] = { 'list_down', mode = { 'i', 'n' } },
        ['<c-k>'] = { 'list_up', mode = { 'i', 'n' } },
        ['<c-n>'] = { 'list_down', mode = { 'i', 'n' } },
        ['<c-p>'] = { 'list_up', mode = { 'i', 'n' } },
        ['<c-q>'] = { 'qflist', mode = { 'i', 'n' } },
        ['<c-s>'] = { 'edit_split', mode = { 'i', 'n' } },
        ['<c-t>'] = { 'tab', mode = { 'n', 'i' } },
        ['<c-u>'] = { 'list_scroll_up', mode = { 'i', 'n' } },
        ['<c-v>'] = { 'edit_vsplit', mode = { 'i', 'n' } },
        ['<c-r>#'] = { 'insert_alt', mode = 'i' },
        ['<c-r>%'] = { 'insert_filename', mode = 'i' },
        ['<c-r><c-a>'] = { 'insert_cWORD', mode = 'i' },
        ['<c-r><c-f>'] = { 'insert_file', mode = 'i' },
        ['<c-r><c-l>'] = { 'insert_line', mode = 'i' },
        ['<c-r><c-p>'] = { 'insert_file_full', mode = 'i' },
        ['<c-r><c-w>'] = { 'insert_cword', mode = 'i' },
        ['<c-w>H'] = 'layout_left',
        ['<c-w>J'] = 'layout_bottom',
        ['<c-w>K'] = 'layout_top',
        ['<c-w>L'] = 'layout_right',
        ['?'] = 'toggle_help_input',
        ['G'] = 'list_bottom',
        ['gg'] = 'list_top',
        ['j'] = 'list_down',
        ['k'] = 'list_up',
        ['q'] = 'cancel',
      },
      b = {
        minipairs_disable = true,
      },
    },
    list = {
      keys = {
        ['/'] = 'toggle_focus',
        ['<2-LeftMouse>'] = 'confirm',
        ['<CR>'] = 'confirm',
        ['<Down>'] = 'list_down',
        ['<Esc>'] = 'cancel',
        ['<S-CR>'] = { { 'pick_win', 'jump' } },
        ['<S-Tab>'] = { 'select_and_prev', mode = { 'n', 'x' } },
        ['<Tab>'] = { 'select_and_next', mode = { 'n', 'x' } },
        ['<Up>'] = 'list_up',
        ['<a-d>'] = 'inspect',
        ['<a-f>'] = 'toggle_follow',
        ['<a-h>'] = 'toggle_hidden',
        ['<a-i>'] = 'toggle_ignored',
        ['<a-m>'] = 'toggle_maximize',
        ['<a-p>'] = 'toggle_preview',
        ['<a-w>'] = 'cycle_win',
        ['<c-a>'] = 'select_all',
        ['<c-b>'] = 'preview_scroll_up',
        ['<c-d>'] = 'list_scroll_down',
        ['<c-f>'] = 'preview_scroll_down',
        ['<c-j>'] = 'list_down',
        ['<c-k>'] = 'list_up',
        ['<c-n>'] = 'list_down',
        ['<c-p>'] = 'list_up',
        ['<c-q>'] = 'qflist',
        ['<c-g>'] = 'print_path',
        ['<c-s>'] = 'edit_split',
        ['<c-t>'] = 'tab',
        ['<c-u>'] = 'list_scroll_up',
        ['<c-v>'] = 'edit_vsplit',
        ['<c-w>H'] = 'layout_left',
        ['<c-w>J'] = 'layout_bottom',
        ['<c-w>K'] = 'layout_top',
        ['<c-w>L'] = 'layout_right',
        ['?'] = 'toggle_help_list',
        ['G'] = 'list_bottom',
        ['gg'] = 'list_top',
        ['i'] = 'focus_input',
        ['j'] = 'list_down',
        ['k'] = 'list_up',
        ['q'] = 'cancel',
        ['zb'] = 'list_scroll_bottom',
        ['zt'] = 'list_scroll_top',
        ['zz'] = 'list_scroll_center',
      },
      wo = {
        conceallevel = 2,
        concealcursor = 'nvc',
      },
    },
    preview = {
      keys = {
        ['<Esc>'] = 'cancel',
        ['q'] = 'cancel',
        ['i'] = 'focus_input',
        ['<a-w>'] = 'cycle_win',
      },
    },
  },
  debug = {
    scores = false,
    -- leaks = true,
    explorer = false,
    files = false,
    grep = false,
    proc = false,
    extmarks = false,
  },
}

return M
