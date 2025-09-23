local M = { 'monaqa/dial.nvim' }

M.config = function()
  local augend = require('dial.augend')

  ---@param elements string[] The elements to cycle through
  ---@param word boolean Whether the elements are words (true) or symbols (false)
  local new = function(elements, word)
    return augend.constant.new({ elements = elements, word = word, cyclic = true })
  end

  local default_switches = {
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
    new({
      'first',
      'second',
      'third',
      'fourth',
      'fifth',
      'sixth',
      'seventh',
      'eighth',
      'ninth',
      'tenth',
    }, false),
    augend.constant.alias.bool,
    new({ 'True', 'False' }, true),
    new({ 'and', 'or' }, true),
    new({ '&&', '||' }, false),
    new({ 'top', 'middle', 'bottom' }, true),
    new({ 'left', 'center', 'right' }, true),
    new({ 'start', 'end' }, true),
    new({ 'row', 'col' }, false),
    new({ 'human', 'mouse' }, true),
  }

  local groups = {
    default = {},
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
      new({ 'fin', 'oza', 'pon' }, false),
      new({ 'Fingolimod', 'Ozanimod', 'Ponesimod' }, false),
      new({ 'phip', 'phf6' }, false),
      new({ 'PHIP', 'PHF6' }, false),
      new({ 'jurkat', 'pf382' }, false),
      new({ 'Jurkat', 'PF382' }, false),
    },
    vim = {
      new({ 'opt', 'start' }, false),
      new({ 'autoload', 'plugin' }, false),
    },
  }

  -- create rmd group as a combination of markdown and r
  groups.rmd = {}
  vim.list_extend(groups.rmd, groups.markdown)
  vim.list_extend(groups.rmd, groups.r)

  -- extend each group with default switches
  for name, group in pairs(groups) do
    vim.list_extend(group, default_switches)
  end

  -- Build dials_by_ft from non-default groups
  local dials_by_ft = {}
  for name, _ in pairs(groups) do
    if name ~= 'default' then
      dials_by_ft[name] = name
    end
  end

  -- Merge with explicit extensions
  -- TODO: FIXME
  local extend = {
    sass = 'css',
    scss = 'css',
    quarto = 'rmd',
    zsh = 'sh',
  }

  vim.g.dials_by_ft = vim.tbl_extend('force', dials_by_ft, extend)

  require('dial.config').augends:register_group(groups)

  ---@param increment boolean
  ---@param g? boolean
  local function dial(increment, g)
    local mode = vim.fn.mode(true)
    local is_visual = mode == 'v' or mode == 'V' or mode == '\22'
    local func = string.format(
      '%s%s%s',
      increment and 'inc' or 'dec',
      g and '_g' or '_',
      is_visual and 'visual' or 'normal'
    )
    -- local group = vim.g.dials_by_ft[vim.bo.filetype] or 'default'
    -- return require('dial.map')[func](group)
    return require('dial.map')[func](vim.g.dials_by_ft[vim.bo.filetype] or 'default')
  end

-- stylua: ignore
local keys = {
  {'<C-a>', function() return dial(true) end, },
  {'<C-x>', function() return dial(false) end,},
  {'g<C-a>', function() return dial(true, true) end,},
  {'g<C-x>', function() return dial(false, true) end, }
}

  for _, keymap in ipairs(keys) do
    local lhs, rhs = unpack(keymap)
    ---@diagnostic disable-next-line: param-type-mismatch
    vim.keymap.set({ 'n', 'v' }, lhs, rhs, { expr = true })
  end
end

return M
