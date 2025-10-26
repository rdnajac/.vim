---@diagnostic disable-next-line
local function reopen(picker, overrides)
  local last = {
    selected = picker:selected({ fallback = false }),
    cursor = picker.list.cursor,
    topline = picker.list.top,
    input = { filter = vim.deepcopy(picker.input.filter) },
    live = picker.opts.live,
    toggles = {},
    cwd = picker:cwd(),
    source = picker.opts.source, -- included in opts
  }

  if picker.opts.toggles then
    for toggle_name in pairs(picker.opts.toggles) do
      last.toggles[toggle_name] = picker.opts[toggle_name]
    end
  end

  picker:close()
  Snacks.picker.pick(vim.tbl_extend('force', last, overrides or {}))
end

---@param picker snacks.Picker
local toggle = function(picker)
  vim.cmd('norm! dd')
  local opts = { cwd = picker.opts.cwd }
  local alt = picker.opts.source == 'grep' and 'files' or 'grep'
  picker:close()
  Snacks.picker(alt, opts)
  -- reopen(picker, { source = alt })
  vim.schedule(function()
    vim.api.nvim_feedkeys(vim.keycode('<C-R>"'), 'i', false)
  end)
end

---@param picker snacks.Picker
local zoxide = function(picker)
  local opts = picker.opts -- deepcopy?
  picker:close()
  Snacks.picker.zoxide({
    confirm = function(z, item)
      z:close()
      opts.cwd = item.file
      Snacks.picker(opts)
      -- reopen(picker, { cwd = item.file })
    end,
  })
end

---@type snacks.picker.Config
return {
  ---@param opts snacks.picker.Config
  config = function(opts)
    local icon_map = { grep = '󰱽', files = '' }
    local icon = icon_map[opts.finder] or ' '
    local name = opts.finder:sub(1, 1):upper() .. opts.finder:sub(2)
    local searchpath = opts.dirs and 'Multiple Paths' or vim.fn.fnamemodify(opts.cwd, ':~')

    opts.title = string.format('%s %s [ %s ]', icon, name, searchpath)
    if nv.is_nonempty_list(opts.ft) then
      opts.title = table.concat(
        vim.list_extend(
          { opts.title },
          vim.tbl_map(function(ft)
            return nv.icons.filetype[ft]
          end, opts.ft)
        ),
        ' '
      )
    end

    if not opts.cwd then
      if vim.bo.filetype == 'oil' then
        opts.cwd = require('oil').get_current_dir()
      -- TODO: write project root func usinglsp
      elseif vim.fn.exists('*git#root') == 1 and vim.fn['git#root']() ~= '' then
        opts.cwd = vim.fn['git#root']()
      else
        opts.cwd = vim.fn.getcwd()
      end
    end

    -- hide the preview window if the screen is too narrow
    if vim.o.columns < 100 or opts.finder == 'grep' then
      opts.layout.auto_hide = { 'preview' }
    end

    return opts
  end,
  actions = {
    toggle = toggle,
    zoxide = zoxide,
  },
  win = {
    input = {
      keys = {
        ['`'] = { 'toggle', mode = { 'i', 'n' } },
        ['~'] = { 'zoxide', mode = { 'i', 'n' } },
        ['P'] = {
          function(p)
            Snacks.debug.inspect(p.opts)
          end,
          mode = { 'n' },
        },
      },
    },
  },
  confirm = 'vsplit'
}
