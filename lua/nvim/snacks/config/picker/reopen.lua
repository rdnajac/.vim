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
  local alt = picker.opts.source == 'files' and 'grep' or 'files'
  reopen(picker, { source = alt })
end

---@param picker snacks.Picker
local zoxide = function(picker)
  picker:close()
  Snacks.picker.zoxide({
    confirm = function(z, item)
      z:close()
      reopen(picker, { cwd = item.file })
    end,
  })
end

