local M = {}

---@type snacks.picker.Config
M.config = {
  layout = {
    preset = 'ivy',
  },
  layouts = {
    vscode = {
      reverse = true,
      layout = {
        box = 'vertical',
        backdrop = false,
        height = 0.4,
        row = vim.o.lines - math.floor(0.4 * vim.o.lines) - 1,
        {
          win = 'list',
          border = 'rounded',
        },
        {
          win = 'input',
          height = 1,
          border = 'rounded',
          title = '{title} {live} {flags}',
          title_pos = 'left',
        },
      },
    },
  },
  win = { preview = { minimal = true } },
  ---@type snacks.picker.matcher.Config
  matcher = {
    frecency = true,
    sort_empty = true,
  },
  sources = {
    autocmds = { confirm = 'edit' },
    buffers = { layout = { preset = 'vscode' } },
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
      -- layout = { preset = 'vscode' },
      follow = true,
      hidden = true,
      ignored = false,
    },
    grep = { follow = true, ignored = true },
    help = { layout = { preset = 'vscode' } },
    keymaps = { layout = { preset = 'ivy_split' }, confirm = 'edit' },
    notifications = { layout = { preset = 'ivy_split' } },
    pickers = { layout = { preset = 'vscode' } },
    zoxide = {
      layout = { preset = 'vscode' },
      confirm = { 'edit' },
    },
  },
}

return M
