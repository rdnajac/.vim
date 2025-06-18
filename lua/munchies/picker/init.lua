local M = {}

---@module "snacks"
---@type snacks.picker.Config
M.config = {
  layout = { preset = 'mylayout' },
  layouts = {
    mylayout = require('munchies.picker.layout'),
    vscode = require('munchies.picker.layout'),
  },
  matcher = {
    frecency = true,
    sort_empty = true,
  },
  sources = {
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
    files = {
      follow = true,
      hidden = true,
      ignored = false,
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
    notifications = { layout = { preset = 'ivy_split' } },
  },
  win = {
    input = {
      keys = {
        ['<Esc>'] = { 'close', mode = { 'n', 'i' } },
        ['<a-z>'] = {
          function(self)
            require('munchies.picker.zoxide').cd_and_resume_picking(self)
          end,
          mode = { 'i', 'n' },
        },
      },
    },
    preview = { minimal = true },
  },
}

return M
