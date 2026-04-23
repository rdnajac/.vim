vim.cmd([[
nnoremap ZB <Cmd>lua Snacks.bufdelete()<CR>
nnoremap Zb <Cmd>lua Snacks.bufdelete.other()<CR>
nnoremap ,. <Cmd>lua Snacks.scratch.open()<CR>
nnoremap ,, <Cmd>lua Snacks.picker.buffers()<CR>
nnoremap ,/ <Cmd>lua Snacks.picker.grep()<CR>
xnoremap /  <Cmd>lua Snacks.picker.grep_word()<CR>
inoremap <C-x><C-i> <Cmd>lua Snacks.picker.icons({ layout = require('munchies').insert })<CR>
inoremap <C-x><C-z> <Cmd>lua Snacks.picker.registers({ layout = require('munchies').insert })<CR>
]])

vim.schedule(function()
  Snacks.util.on_key('<Esc>', function() vim.cmd.nohlsearch() end)
  Snacks.keymap.set({ 'n' }, 'K', vim.lsp.buf.hover, { lsp = {} })
  Snacks.keymap.set({ 'n', 'x' }, '<M-CR>', Snacks.debug.run, { ft = 'lua' })

  -- normal and terminal mode keymaps
  vim
    .iter({
      ['<C-Bslash>'] = function() Snacks.terminal.focus() end,
      [']]'] = function() Snacks.words.jump(vim.v.count1) end,
      ['[['] = function() Snacks.words.jump(-vim.v.count1) end,
    })
    :each(function(lhs, rhs) vim.keymap.set({ 'n', 't' }, lhs, rhs) end)
end)

  local icons= {
    buffers = '',
    explorer = '󰙅',
    files = '',
    grep = '󰱽',
  }
local function title(self)
  local picker = self.source
  local icon = icons[picker] or ''
  local name = picker and picker:sub(1, 1):upper() .. picker:sub(2)
  local dir = self.dirs and #self.dirs .. ' paths'
    or vim.fn.pathshorten(vim.fn.fnamemodify(self.cwd or vim.fn.getcwd(), ':~'), 2)
  local extra = ''
  -- add filetype icons if filtering by filetype
  if self.ft then
    local ftlist = type(self.ft) == 'table' and self.ft or { self.ft }
    extra = extra
      .. vim.iter(ftlist):map(function(ft) return nv.ui.icons.filetype[ft] or '?' end):join('  ')
  end
  return string.format('%s %s [%s] %s', icon, name, dir, extra)
end

---@type table<string, fun(snacks.picker.Config):nil>
local actions = {
  set_title = function(self) self.title = title(self) end,
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
  end,
  inspect_self = function(self) Snacks.debug.inspect(self) end,
  inspect_opts = function(self) Snacks.debug.inspect(self.opts) end,
}

vim.schedule(function()
  Snacks.config.style('lazygit', { height = 0, width = 0 })
  Snacks.keymap.set({ 'x' }, '<M-CR>', Snacks.debug.run, { ft = 'markdown' })
  vim.iter(require('munchies.toggles')):each(function(k, v)
    local toggle
    if type(v) == 'function' then
      toggle = v()
    elseif type(v) == 'table' then
      toggle = Snacks.toggle.new(v)
    elseif type(v) == 'string' then
      toggle = Snacks.toggle.option(v)
    end
    if not toggle then
      error(('Invalid toggle for key: %s'):format(k))
    end
    toggle:map(k)
  end)
end)

local layouts = require('munchies.layouts')
return {
  insert = layouts.insert,
  mylayout = layouts.mylayout,
  ---@class snacks.picker.Config
  picker = {
    actions = actions,
    ---@param self snacks.picker.Config
    config = function(self)
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
      -- hide the preview window if the screen is too narrow
      -- self.layout.auto_hide = vim.o.columns < 100 and { 'preview' } or opts.layout.auto_hide
      actions.set_title(self)
      return self
    end,
    db = { sqlite3_path = nil }, -- TODO:
    sources = {
      explorer = {
        ignored = true, -- always show git ignored files
        jump = { close = true }, -- close buffer after selecting a file
        on_show = require('munchies.explorer').floating_preview,
        win = {
          preview = { border = 'rounded', focusable = false },
          list = {
            keys = {
              ['/'] = 'picker_grep',
              ['-'] = 'explorer_up',
              ['<Left>'] = 'explorer_up',
              ['<Right>'] = 'confirm',
            },
          },
        },
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
      resume = { exclude = 'pickers' },
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
      git = { args = {} },
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
        -- b = { minipairs_disable = true },
        keys = {
          ['?'] = 'toggle_help_input',
          ['/'] = 'toggle_focus',
          ['G'] = 'list_bottom',
          ['gg'] = 'list_top',
          ['j'] = 'list_down',
          ['k'] = 'list_up',
          ['q'] = 'cancel',

          ['<C-a>'] = { 'select_all', mode = { 'n', 'i' } },
          ['<C-c>'] = { 'cancel', mode = 'i' },
          ['<C-d>'] = { 'list_scroll_down', mode = { 'i', 'n' } },
          ['<C-f>'] = { mode = { 'i', 'n' }, 'toggle' }, -- XXX:
          -- ['<C-f>'] = { 'preview_scroll_down', mode = { 'i', 'n' } },
          ['<C-g>'] = { 'toggle_live', mode = { 'i', 'n' } },
          ['<C-j>'] = { 'list_down', mode = { 'i', 'n' } },
          ['<C-k>'] = { 'list_up', mode = { 'i', 'n' } },
          ['<C-n>'] = { 'list_down', mode = { 'i', 'n' } },
          ['<C-p>'] = { 'list_up', mode = { 'i', 'n' } },
          ['<C-q>'] = { 'qflist', mode = { 'i', 'n' } },
          -- insert text
          ['<C-r>#'] = { 'insert_alt', mode = 'i' },
          ['<C-r>%'] = { 'insert_filename', mode = 'i' },
          ['<C-r><c-a>'] = { 'insert_cWORD', mode = 'i' },
          ['<C-r><c-f>'] = { 'insert_file', mode = 'i' },
          ['<C-r><c-l>'] = { 'insert_line', mode = 'i' },
          ['<C-r><c-p>'] = { 'insert_file_full', mode = 'i' },
          ['<C-r><c-w>'] = { 'insert_cword', mode = 'i' },

          ['<C-w>'] = { '<c-s-w>', mode = { 'i' }, expr = true, desc = 'delete word' },

          ['<C-s>'] = { 'edit_split', mode = { 'i', 'n' } },
          ['<C-t>'] = { 'tab', mode = { 'n', 'i' } },
          ['<C-u>'] = { 'list_scroll_up', mode = { 'i', 'n' } },
          ['<C-v>'] = { 'edit_vsplit', mode = { 'i', 'n' } },

          ['<C-w>H'] = 'layout_left',
          ['<C-w>J'] = 'layout_bottom',
          ['<C-w>K'] = 'layout_top',
          ['<C-w>L'] = 'layout_right',

          ['<Up>'] = { 'list_up', mode = { 'i', 'n' } },
          ['<Down>'] = { 'list_down', mode = { 'i', 'n' } },

          ['<Esc>'] = 'cancel',
          ['<CR>'] = { 'confirm', mode = { 'n', 'i' } },
          ['<Tab>'] = { 'select_and_next', mode = { 'i', 'n' } },
          ['<S-CR>'] = { { 'pick_win', 'jump' }, mode = { 'n', 'i' } },
          ['<S-Tab>'] = { 'select_and_prev', mode = { 'i', 'n' } },

          ['<M-c>'] = { 'clear', mode = { 'i', 'n' } },
          ['<M-d>'] = { 'inspect', mode = { 'i', 'n' } },
          ['<M-f>'] = { 'toggle_follow', mode = { 'i', 'n' } },
          ['<M-h>'] = { 'toggle_hidden', mode = { 'i', 'n' } },
          ['<M-i>'] = { 'toggle_ignored', mode = { 'i', 'n' } },
          ['<M-m>'] = { 'toggle_maximize', mode = { 'i', 'n' } },
          ['<M-p>'] = { 'toggle_preview', mode = { 'i', 'n' } },
          ['<M-r>'] = { 'toggle_regex', mode = { 'i', 'n' } },
          ['<M-w>'] = { 'cycle_win', mode = { 'i', 'n' } },
          ['<M-z>'] = { 'zoxide', mode = { 'i', 'n' } },
        },
      },
      list = {
        wo = { conceallevel = 2, concealcursor = 'nvc' },
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
  },
}
