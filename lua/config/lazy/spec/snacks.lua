---@module "snacks"
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
        -- command_history = { layout = { preset = 'vscode' }, confirm = 'cmd' },
        notifications = { layout = { preset = 'ivy_split' } },
        keymaps = { layout = { preset = 'ivy_split' }, confirm = 'edit' },
        autocmds = { layout = { confirm = 'edit' } },
        buffers = { layout = { preset = 'vscode' } },
        help = { layout = { preset = 'vscode' } },
        files = {
          layout = { preset = 'sidebar' },
          follow = true,
          hidden = true,
          ignored = false,
        },
        grep = { follow = true, ignored = true },
        pickers = { layout = { preset = 'vscode' } },
        zoxide = {
          layout = { preset = 'vscode' },
          confirm = { 'edit' },
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
