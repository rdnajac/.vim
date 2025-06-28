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
  explorer = {
    cwd = vim.fn.getcwd(),
    ignored = true,
    win = {
      list = {
        keys = {
          ['<BS>'] = 'explorer_up',
          ['l'] = 'confirm',
          ['h'] = 'explorer_close', -- close directory
          ['a'] = 'explorer_add',
          ['d'] = 'explorer_del',
          ['r'] = 'explorer_rename',
          ['c'] = 'explorer_copy',
          ['m'] = 'explorer_move',
          ['o'] = 'explorer_open', -- open with system application
          ['P'] = 'toggle_preview',
          ['y'] = { 'explorer_yank', mode = { 'n', 'x' } },
          ['p'] = 'explorer_paste',
          ['u'] = 'explorer_update',
          ['<c-c>'] = 'tcd',
          ['<leader>/'] = 'picker_grep',
          ['<c-t>'] = 'terminal',
          ['.'] = 'explorer_focus',
          ['I'] = 'toggle_ignored',
          ['H'] = 'toggle_hidden',
          ['Z'] = 'explorer_close_all',
          [']g'] = 'explorer_git_next',
          ['[g'] = 'explorer_git_prev',
          [']d'] = 'explorer_diagnostic_next',
          ['[d'] = 'explorer_diagnostic_prev',
          [']w'] = 'explorer_warn_next',
          ['[w'] = 'explorer_warn_prev',
          [']e'] = 'explorer_error_next',
          ['[e'] = 'explorer_error_prev',
        },
      },
    },
  },
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
