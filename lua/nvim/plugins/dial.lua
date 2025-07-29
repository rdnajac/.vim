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

-- stylua: ignore
M.keys =  {
  {{ 'n', 'v' }, '<C-a>', function() return M.dial(true) end, { expr = true, desc = 'Increment' }},
  {{ 'n', 'v' }, '<C-x>', function() return M.dial(false) end, { expr = true, desc = 'Decrement' }},
  {{ 'n', 'v' }, 'g<C-a>', function() return M.dial(true, true) end, { expr = true, desc = 'Increment' }},
  {{ 'n', 'v' }, 'g<C-x>', function() return M.dial(false, true) end, { expr = true, desc = 'Decrement' }},
}

-- stylua: ignore
M.keymaps = function()
  for _, keymap in ipairs(M.keys) do
    local modes, lhs, rhs, opts = unpack(keymap)
    ---@diagnostic disable-next-line: param-type-mismatch
    vim.keymap.set(modes, lhs, rhs, opts)
  end
end

M.opts = function()
  local augend = require('dial.augend')

  ---@param elements string[] The elements to cycle through
  ---@param word boolean Whether the elements are words (true) or symbols (false)
  local new = function(elements, word)
    return augend.constant.new({ elements = elements, word = word, cyclic = true })
  end

  local opts = {
    default = {
      augend.integer.alias.decimal,
      augend.integer.alias.decimal_int,
      augend.integer.alias.hex,
      augend.date.alias['%Y/%m/%d'],
      augend.constant.alias.en_weekday_full,
      new({
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
      new({ 'first', 'second', 'third', 'fourth', 'fifth', 'sixth', 'seventh', 'eighth', 'ninth', 'tenth' }, false),
      augend.constant.alias.bool,
      new({ 'True', 'False' }, true),
      new({ 'and', 'or' }, true),
      new({ '&&', '||' }, false),
      new({ 'top', 'middle', 'bottom' }, true),
      new({ 'left', 'center', 'right' }, true),
      new({ 'start', 'end' }, true),
      new({ 'rows', 'cols' }, true),
      new({ 'human', 'mouse' }, true),
    },
    json = { augend.semver.alias.semver },
    css = {
      augend.hexcolor.new({ case = 'lower' }),
      augend.hexcolor.new({ case = 'upper' }),
    },
    markdown = {
      augend.misc.alias.markdown_header,
      new({ '[ ]', '[x]' }, false),
    },
    r = {
      new({ 'TRUE', 'FALSE' }, false),
      new({ 'row', 'col' }, false),
    },
    vim = {
      new({ 'opt', 'start' }, false),
      new({ 'autoload', 'plugin' }, false),
    },
  }

  for name, group in pairs(opts) do
    if name ~= 'default' then
      vim.list_extend(group, opts.default)
    end
  end
  return opts
end

M.config = function()
  local opts = M.opts()

  -- Build dials_by_ft from non-default groups
  local dials_by_ft = {}
  for name, _ in pairs(opts) do
    if name ~= 'default' then
      dials_by_ft[name] = name
    end
  end

  -- Merge with explicit extensions
  local extend = {
    sass = 'css',
    scss = 'css',
    quarto = 'markdown',
  }

  dials_by_ft = vim.tbl_extend('force', dials_by_ft, extend)

  vim.g.dials_by_ft = dials_by_ft

  require('dial.config').augends:register_group(opts)
  M.keymaps()
end

return M
