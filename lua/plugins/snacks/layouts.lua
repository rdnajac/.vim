---@module "snacks"
return {
  ---@type snacks.picker.layout.Config
  mylayout = {
    reverse = true,
    layout = {
      box = 'vertical',
      backdrop = false,
      height = 0.4,
      row = vim.o.lines - math.floor(0.4 * vim.o.lines),
      { win = 'list', border = 'rounded', title_pos = 'left' },
      { win = 'input', height = 1 },
    },
    { win = 'input', height = 1 },
  },
}
