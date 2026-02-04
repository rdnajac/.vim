-- local m = MiniIcons

local items = vim.fn.globpath(vim.g.plug_home, '*', true, true)

local entries = {}
for _, path in ipairs(items) do
  table.insert(entries, {
    text = vim.fs.basename(path),
    value = path,
  })
end

Snacks.picker({
  layout = {
    preview = false,
  },
  win = {
    input = {
      keys = {
        ['<C-s>'] = { 'live_grep', mode = { 'i', 'n' } },
        ['<M-r>'] = { 'oldfiles', mode = { 'i', 'n' } },
      },
    },
  },
  finder = function()
    local items = {
      {
        _select_key = '/home/your_username/.config/nvim',
        idx = 1,
        score = 1000,
        text = '/home/your_username/.config/nvim',
      },
    }
    return items
  end,
  format = 'text',
  actions = {
    confirm = function(picker, item) Snacks.picker.files({ cwd = item.file }) end,
    live_grep = function(picker, item) Snacks.picker.pick('grep', { cwd = item.file }) end,
    oldfiles = function(_, item) Snacks.picker.recent({ cwd = item.file }) end,
  },
})
