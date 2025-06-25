local M = {}

---@module "snacks"

---@param picker snacks.Picker
local function toggle(picker)
  local cwd = picker:cwd()
  local alt = picker.opts.source == 'files' and 'grep' or 'files'
  picker:close()
  Snacks.picker(alt, { cwd = cwd })
end

---@type snacks.picker.sources.Config|{}|table<string, snacks.picker.Config|{}>
M.sources = {
  keymaps = { confirm = 'edit', layout = { preset = 'mylayout' } },
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
    win = {
      input = {
        keys = {
          ['<a-t>'] = { 'toggle', mode = { 'n', 'i' }, desc = 'Toggle Files/Grep' },
        },
      },
    },
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
    -- stylua: ignore
    actions = { toggle = function(self) toggle(self) end, },
    win = {
      input = {
        keys = {
          ['<a-t>'] = { 'toggle', mode = { 'n', 'i' }, desc = 'Toggle Files/Grep' },
        },
      },
    },
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
}

return M
