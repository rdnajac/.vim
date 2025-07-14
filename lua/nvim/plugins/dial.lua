local M = { 'monaqa/dial.nvim' }

M.event = 'BufWinEnter'

---@param increment boolean
---@param g? boolean
function M.dial(increment, g)
  local mode = vim.fn.mode(true)
  local is_visual = mode == 'v' or mode == 'V' or mode == '\22'
  local func = (increment and 'inc' or 'dec') .. (g and '_g' or '_') .. (is_visual and 'visual' or 'normal')
  local group = vim.g.dials_by_ft[vim.bo.filetype] or 'default'
  return require('dial.map')[func](group)
end

M.keymaps = function()
  vim.keymap.set({ 'n', 'v' }, '<C-a>', function()
    return M.dial(true)
  end, { expr = true, desc = 'Increment' })
  vim.keymap.set({ 'n', 'v' }, '<C-x>', function()
    return M.dial(false)
  end, { expr = true, desc = 'Decrement' })
  vim.keymap.set({ 'n', 'v' }, 'g<C-a>', function()
    return M.dial(true, true)
  end, { expr = true, desc = 'Increment' })
  vim.keymap.set({ 'n', 'v' }, 'g<C-x>', function()
    return M.dial(false, true)
  end, { expr = true, desc = 'Decrement' })
end

M.opts = function()
  local augend = require('dial.augend')
  local new_dial = function(elements, word)
    return augend.constant.new({ elements = elements, word = word, cyclic = true })
  end

  local opts = {
    dials_by_ft = {
      css = 'css',
      sass = 'css',
      scss = 'css',
      json = 'json',
      markdown = 'markdown',
      quarto = 'markdown',
      r = 'r',
    },
    groups = {
      default = {
        augend.integer.alias.decimal,
        augend.integer.alias.decimal_int,
        augend.integer.alias.hex,
        augend.date.alias['%Y/%m/%d'],
        augend.constant.alias.en_weekday_full,
        new_dial({
          'January',
          'February',
          'March',
          'April',
          'May',
          'June',
          'July',
          'August',
          'September',
          'October',
          'November',
          'December',
        }, true),
        new_dial(
          { 'first', 'second', 'third', 'fourth', 'fifth', 'sixth', 'seventh', 'eighth', 'ninth', 'tenth' },
          false
        ),
        augend.constant.alias.bool,
        new_dial({ 'True', 'False' }, true),
        new_dial({ 'and', 'or' }, true),
        new_dial({ '&&', '||' }, false),
        new_dial({ 'top', 'middle', 'bottom' }, true),
        new_dial({ 'left', 'center', 'right' }, true),
        new_dial({ 'start', 'end' }, true),
        new_dial({ 'rows', 'cols' }, true),
        new_dial({ 'human', 'mouse' }, true),
      },
      json = { augend.semver.alias.semver },
      css = {
        augend.hexcolor.new({ case = 'lower' }),
        augend.hexcolor.new({ case = 'upper' }),
      },
      markdown = {
        augend.misc.alias.markdown_header,
        new_dial({ '[ ]', '[x]' }, false),
      },
      r = {
        new_dial({ 'TRUE', 'FALSE' }, false),
        new_dial({ 'row', 'col' }, false),
        new_dial({ 'PHIP', 'PHF6' }, false),
      },
    },
  }

  return opts
end

M.config = function()
  local opts = M.opts()
  local default = opts.groups.default

  for name, group in pairs(opts.groups) do
    if name ~= 'default' then
      vim.list_extend(group, default)
    end
  end

  require('dial.config').augends:register_group(opts.groups)
  vim.g.dials_by_ft = opts.dials_by_ft
  M.keymaps()
end

return M
