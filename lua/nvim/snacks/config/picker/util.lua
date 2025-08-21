local M = {}

---@param picker snacks.Picker
local toggle = function(picker)
  -- local f = picker:filter()
  local opts = {
    cwd = picker.opts.cwd,
  }
  -- if picker.opts.live then
  --   opts.input.search = f.search
  -- else
  --   opts.input.pattern = f.pattern
  -- end
  if picker.opts.source == 'grep' then
    Snacks.picker.files(opts)
  else
    Snacks.picker.grep(opts)
  end
end

---@param picker snacks.Picker
local zoxide = function(picker)
  local opts = picker.opts

  picker:close()
  Snacks.picker.zoxide({
    confirm = function(z, item)
      z:close()
      opts.cwd = item.file
      Snacks.picker.pick(opts)
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
    opts.title =
      string.format('%s %s [ %s ]', icon, name, vim.fn.fnamemodify(opts.cwd, ':~'))
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
