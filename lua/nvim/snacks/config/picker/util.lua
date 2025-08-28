local M = {}

---@param picker snacks.Picker
local toggle = function(picker)
  vim.cmd('norm! dd')
  local opts = { cwd = picker.opts.cwd }
  local alt = picker.opts.source == 'grep' and 'files' or 'grep'

  picker:close()
  Snacks.picker(alt, opts)
  vim.schedule(function()
    vim.api.nvim_feedkeys(vim.keycode('<C-R>"'), 'i', false)
  end)
end

---@param picker snacks.Picker
local zoxide = function(picker)
  local opts = picker.opts

  picker:close()
  Snacks.picker.zoxide({
    confirm = function(z, item)
      z:close()
      opts.cwd = item.file
      Snacks.picker(opts)
    end,
  })
end

-- TODO: Find command scriptnames picker in git history
M.pick_conf = {
  confirm = 'edit',
}

M.opts_extend = {
  actions = {
    toggle = function(self)
      toggle(self)
    end,
    zoxide = function(self)
      zoxide(self)
    end,
  },
  config = function(opts)
    local icon_map = {
      grep = '󰱽',
      files = '',
    }
    local icon = icon_map[opts.finder]
    local name = opts.finder:sub(1, 1):upper() .. opts.finder:sub(2)
    opts.title = string.format('%s %s [ %s ]', icon, name, vim.fn.fnamemodify(opts.cwd, ':~'))
    opts.cwd = opts.cwd or vim.fn['git#root']() or vim.fn.getcwd()
    return opts
  end,
  win = {
    input = {
      keys = {
        ['`'] = { 'toggle', mode = { 'i', 'n' } },
        ['~'] = { 'zoxide', mode = { 'i', 'n' } },
        ['P'] = {
          function(p)
            ddd(p.opts)
            -- ddd(p)
          end,
          mode = { 'n' },
        },
      },
    },
  },
}

return M
