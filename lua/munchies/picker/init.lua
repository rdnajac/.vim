local M = {}

---@type snacks.picker.Config
M.config = {
  layout = { preset = 'mylayout' },
  layouts = { mylayout = require('munchies.picker.layout') },
  win = { preview = { minimal = true } },
  ---@type snacks.picker.matcher.Config
  matcher = {
    frecency = true,
    sort_empty = true,
  },
  sources = {
    autocmds = { confirm = 'edit' },
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
      hidden = true,
      ignored = false,
      win = {
        input = {
          keys = {
            ['<Esc>'] = { 'close', mode = { 'n', 'i' } },
            ['<a-z>'] = {
              function(self)
                self:close()
                Snacks.picker.zoxide({
                  confirm = function(_, item)
                    vim.cmd('cd ' .. vim.fn.fnameescape(item.file))
                    vim.cmd('pwd')
                    Snacks.picker.resume({ cwd = item.file })
                  end,
                })
              end,
              mode = { 'i', 'n' },
            },
          },
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
      ignored = true,
    },
    help = { confirm = 'vsplit' }, -- TODO: keymap?
    keymaps = { confirm = 'edit' },
    notifications = { layout = { preset = 'ivy_split' } },
  },
}

return M
