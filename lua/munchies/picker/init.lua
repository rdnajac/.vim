local M = {}

---@type snacks.picker.sources.Config
M.sources = {
  autocmds = { confirm = 'edit' },
  keymaps = { confirm = 'edit' },
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
  notifications = { layout = { preset = 'ivy' } },
  pickers = { layout = { preset = 'ivy' } },
  undo = { layout = { preset = 'ivy' } },
  files = {
    follow = true,
    hidden = true,
    ignored = false,
  },
  recent = {
    filter = {
      paths = {
        [vim.fn.stdpath('data')] = true,
        [vim.fn.stdpath('cache')] = false,
        [vim.fn.stdpath('state')] = false,
      },
    },
  },
  grep = {
    config = function(opts)
      local cwd = opts.cwd or vim.loop.cwd()
      opts.title = '󰱽 Grep (' .. vim.fn.fnamemodify(cwd, ':~') .. ')'
      return opts
    end,
    follow = true,
    ignored = false,
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
        { win = 'input', height = 1, border = 'rounded', title = '{title} {live} {flags}', title_pos = 'center' },
        { win = 'list', border = 'rounded' },
      },
    },
  },
}

return M
