return {
  'folke/snacks.nvim',
  priority = 1000,
  opts = {
    bigfile = { enabled = true },
    ---@type snacks.dashboard.Config
    dashboard = {
      sections = {
        { section = 'header' },
        { section = 'keys', padding = 1 },
        { section = 'startup' },
      },
      preset = {
        ---@type snacks.dashboard.Item[]
        keys = {
          { icon = ' ', title = 'Recent Files' },
          { section = 'recent_files', indent = 2, gap = 0 },
          { icon = ' ', key = 'c', desc = 'Config', action = '<leader>fc' },
          -- TODO add config shortcuts
          { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
        },
      },
    },
    explorer = { enabled = false },
    image = { enabled = true },
    indent = { indent = { only_current = true, only_scope = true } },
    input = { enabled = true },
    notifier = { style = 'fancy', date_format = '%T', timeout = 4000 },
    ---@type snacks.picker.Config
    picker = {
      layouts = {
        vscode = {
          layout = {
            backdrop = false,
            row = 1,
            width = 0.4,
            min_width = 80,
            height = 0.4,
            -- border = 'rounded',
            box = 'vertical',
            {
              win = 'input',
              height = 1,
              -- border = 'rounded',
              title = '{title} {live} {flags}',
              title_pos = 'center',
            },
            { win = 'list', border = 'none' },
          },
        },
      },
      win = { preview = { minimal = true } },
      sources = {
        -- command_history = { layout = { preset = 'vscode' }, confirm = 'cmd' },
        autocmds = { layout = { preset = 'ivy' }, confirm = 'edit' },
        buffers = { layout = { preset = 'vscode' } },
        commands = { layout = { preset = 'ivy' } },
        files = { layout = { preset = 'sidebar' } },
        grep = { layout = { preset = 'ivy' }, follow = true, ignored = true },
        help = { layout = { preset = 'ivy' } },
        keymaps = { layout = { preset = 'ivy_split' }, confirm = 'edit' },
        notifications = { layout = { preset = 'ivy_split' }, confirm = 'edit' },
        pickers = { layout = { preset = 'vscode' } },
        zoxide = {
          layout = { preset = 'vscode' },
          confirm = { 'edit' },
          --      confirm = function(self, item)
          --        local dir = item.path or item.filename or item.value or item.text
          --        if type(dir) ~= 'string' or dir == '' then
          --          vim.notify('No valid directory found', vim.log.levels.WARN)
          --          return
          --        end
          --        local win = vim.api.nvim_get_current_win()
          --
          --        vim.cmd('leftabove vsplit ' .. vim.fn.fnameescape(dir))
          --        vim.cmd('vertical resize ' .. math.floor(vim.o.columns * 0.2))
          --        vim.cmd('cd ' .. vim.fn.fnameescape(dir))
          -- vim.cmd('pwd')
          --        vim.api.nvim_set_current_win(win)
          --      end,
        },
      },
    },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    terminal = {
      start_insert = true,
      auto_insert = false,
      auto_close = true,
      win = { wo = { winbar = '', winhighlight = 'Normal:SpecialWindow' } },
    },
    words = { enabled = true },
  },
}
