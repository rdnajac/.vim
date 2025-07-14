local M = {}

---@module "snacks"

---@param picker snacks.Picker
local function toggle(picker)
  local cwd = picker:cwd()
  local alt = picker.opts.source == 'files' and 'grep' or 'files'
  picker:close()
  Snacks.picker(alt, { cwd = cwd })
end

---@type snacks.picker.Config {{{
M.config = {
  layout = { preset = 'ivy' }, -- default layout for pickers
  layouts = {
    ---@type snacks.picker.layout.Config
    mylayout = {
      reverse = true,
      layout = {
        box = 'vertical',
        backdrop = false,
        height = 0.4,
        row = vim.o.lines - math.floor(0.4 * vim.o.lines),
        {
          win = 'list',
          border = 'rounded',
          -- TODO: set titles in picker calls
          title = '{title} {live} {flags}',
          title_pos = 'left',
        },
        {
          win = 'input',
          height = 1,
        },
      },
      {
        win = 'input',
        height = 1,
      },
    },
  },
  ---@type snacks.picker.sources.Config|{}|table<string, snacks.picker.Config|{}>
  sources = {
    explorer = require('munchies.picker.explorer'),
    keymaps = {
      confirm = function(picker, item)
        picker:close()
        -- TODO: use vsplit-drop
        vim.cmd('edit ' .. item.file)
      end,
      layout = { preset = 'mylayout' },
    },
    notifications = { layout = { preset = 'ivy' } },
    pickers = { layout = { preset = 'ivy' } },
    undo = { layout = { preset = 'ivy' } },
    commands = {
      confirm = function(picker, item)
        picker:close()
        if item.command then
          local sid = item.command.script_id
          if sid and sid ~= 0 then
            local src
            for line in vim.fn.execute('scriptnames'):gmatch('[^\r\n]+') do
              local id, path = line:match('^%s*(%d+):%s+(.+)$')
              if tonumber(id) == sid then
                src = path
                break
              end
            end
            if src then
              vim.cmd('edit ' .. src)
              vim.fn.search('\\<' .. item.cmd .. '\\>', 'w')
            end
          end
        end
      end,
    },
    files = {
      follow = true,
      hidden = false,
      ignored = false,
      -- stylua: ignore
      actions = { toggle = function(self) toggle(self) end, },
    },
    grep = {
      config = function(opts)
        local cwd = opts.cwd or vim.loop.cwd()
        opts.title = '󰱽 Grep (' .. vim.fn.fnamemodify(cwd, ':~') .. ')'
        return opts
      end,
      follow = true,
      ignored = false,
      actions = {
        toggle = function(self)
          toggle(self)
        end,
      }, -- stylua: ignore
    },
    icons = {
      layout = {
        layout = {
          reverse = true,
          relative = 'cursor',
          row = 1,
          width = 0.3,
          min_width = 48,
          height = 0.3,
          border = 'none',
          box = 'vertical',
          { win = 'input', height = 1, border = 'rounded' },
          { win = 'list', border = 'rounded' },
        },
      },
    },
  },
  win = {
    input = {
      keys = {
        ['<Esc>'] = { 'close', mode = { 'n' } },
        ['<a-j>'] = { 'toggle', mode = { 'n', 'i' }, desc = 'Toggle Files/Grep' },
        ['<a-z>'] = {
          function(self)
            require('munchies.picker.zoxide').cd_and_resume_picking(self)
            -- Snacks.picker.actions.cd(_, item)
            -- Snacks.picker.actions.lcd(_, item)
          end,
          mode = { 'i', 'n' },
        },
        -- ['<C-Down>'] = { 'history_forward', mode = { 'i', 'n' } },
        -- ['<C-Up>'] = { 'history_back', mode = { 'i', 'n' } },
        -- ['<C-c>'] = { 'cancel', mode = 'i' },
        -- ['<C-w>'] = { '<c-s-w>', mode = { 'i' }, expr = true, desc = 'delete word' },
        -- ['<CR>'] = { 'confirm', mode = { 'n', 'i' } },
        -- ['<Down>'] = { 'list_down', mode = { 'i', 'n' } },
        -- ['<S-CR>'] = { { 'pick_win', 'jump' }, mode = { 'n', 'i' } },
        -- ['<S-Tab>'] = { 'select_and_prev', mode = { 'i', 'n' } },
        -- ['<Tab>'] = { 'select_and_next', mode = { 'i', 'n' } },
        -- ['<Up>'] = { 'list_up', mode = { 'i', 'n' } },
        -- ['<a-h>'] = { 'toggle_hidden', mode = { 'i', 'n' } },
        -- ['<a-i>'] = { 'toggle_ignored', mode = { 'i', 'n' } },
        -- ['<a-m>'] = { 'toggle_maximize', mode = { 'i', 'n' } },
        -- ['<a-p>'] = { 'toggle_preview', mode = { 'i', 'n' } },
        -- ['<a-w>'] = { 'cycle_win', mode = { 'i', 'n' } },
        -- ['<c-f>'] = { 'preview_scroll_down', mode = { 'i', 'n' } },
        -- ['<c-g>'] = { 'toggle_live', mode = { 'i', 'n' } },
        -- ['<c-j>'] = { 'list_down', mode = { 'i', 'n' } },
        -- ['<c-k>'] = { 'list_up', mode = { 'i', 'n' } },
        -- ['<c-n>'] = { 'list_down', mode = { 'i', 'n' } },
        -- ['<c-p>'] = { 'list_up', mode = { 'i', 'n' } },
        -- ['<c-q>'] = { 'qflist', mode = { 'i', 'n' } },
        -- ['<c-s>'] = { 'edit_split', mode = { 'i', 'n' } },
        -- ['<c-t>'] = { 'tab', mode = { 'n', 'i' } },
        -- ['<c-u>'] = { 'list_scroll_up', mode = { 'i', 'n' } },
        -- ['<c-v>'] = { 'edit_vsplit', mode = { 'i', 'n' } },
        -- remove insert mode keymaps that conflict with vim-rsi
        -- <M-d> Delete forwards one word.
        ['<a-d>'] = { 'inspect', mode = { 'n' } },
        -- <M-f> Go forwards one word.
        ['<a-f>'] = { 'toggle_follow', mode = { 'n' } },
        -- <C-a> Go to beginning of line.
        ['<c-a>'] = { 'select_all', mode = { 'n' } },
        -- <C-b> Go backwards one character.  On a blank line, kill it
        ['<c-b>'] = { 'preview_scroll_up', mode = { 'n' } },
        -- <C-d> Delete character in front of cursor.  Falls back to
        ['<c-d>'] = { 'list_scroll_down', mode = { 'n' } },
      },
    },
    preview = { minimal = true },
  },
}

return M
