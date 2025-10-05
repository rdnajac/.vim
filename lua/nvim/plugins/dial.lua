local M = { 'monaqa/dial.nvim' }
-- TODO:
M.event = 'InsertEnter'

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
      new({ 'sgID2', 'agx51' }, false),
      new({ 'SGID2', 'AGX51' }, false),
    },
    vim = {
      new({ 'opt', 'start' }, false),
      new({ 'autoload', 'plugin' }, false),
    },
    sh = {},
  }

  -- create rmd group as a combination of markdown and r
  groups.rmd = {}
  vim.list_extend(groups.rmd, groups.markdown)
  vim.list_extend(groups.rmd, groups.r)

  -- extend each group with default switches
  for name, group in pairs(groups) do
    vim.list_extend(group, default_switches)
  end

  require('dial.config').augends:register_group(groups)

  -- Filetype mappings for dial groups
  local ft_mappings = {
    sass = 'css',
    scss = 'css',
    quarto = 'rmd',
    zsh = 'sh',
  }

  -- Set up autocommand to populate vim.b.dials based on filetype
  vim.api.nvim_create_autocmd({ 'BufEnter', 'FileType' }, {
    group = vim.api.nvim_create_augroup('dial_buffer_setup', { clear = true }),
    callback = function()
      local ft = vim.bo.filetype
      if ft == '' then
        return
      end
      
      -- Check if there's an explicit mapping
      if ft_mappings[ft] then
        vim.b.dials = ft_mappings[ft]
      -- Check if there's a group for this filetype
      elseif groups[ft] then
        vim.b.dials = ft
      -- Otherwise, don't set vim.b.dials (will fall back to 'default' in the dial function)
      end
    end,
  })

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
    -- Use vim.b.dials if set, otherwise default to 'default'
    local group = vim.b.dials or 'default'
    return require('dial.map')[func](group)
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
