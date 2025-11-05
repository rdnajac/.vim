local dials_by_ft = {
  -- sass = 'css',
  -- scss = 'css',
  quarto = 'rmd',
  zsh = 'sh',
}

return {
  'monaqa/dial.nvim',
  event = 'BufWinEnter',
  debug = function()
    return dials_by_ft
  end,
  config = function()
    local augend = require('dial.augend')

    ---@param elements string[] The elements to cycle through
    ---@param word? boolean Whether the elements are words (true) or symbols (false). Default: false
    ---@param cyclic? boolean Whether the cycle is cyclic (true) or not (false). Default: true
    local new = function(elements, word, cyclic)
      return augend.constant.new({ elements = elements, word = word ~= true, cyclic = cyclic ~= false })
    end

    local default_switches = {
      augend.integer.alias.decimal,
      augend.integer.alias.decimal_int,
      augend.integer.alias.hex,
      augend.date.alias['%Y/%m/%d'],
      augend.constant.alias.en_weekday_full,
      augend.constant.alias.bool,
      new({ 'True', 'False' }, true),
      new({ 'and', 'or' }, true),
      new({ '&&', '||' }),
      new({ 'top', 'middle', 'bottom' }, true),
      new({ 'left', 'center', 'right' }, true),
      new({ 'start', 'end' }, true),
      new({ 'row', 'col' }),
      new({ 'human', 'mouse' }),
    -- stylua: ignore start
    new({ 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December' }, true),
    new({ 'first', 'second', 'third', 'fourth', 'fifth', 'sixth', 'seventh', 'eighth', 'ninth', 'tenth' }),
    }

    local groups = {
      default = {},
      css = {
        augend.hexcolor.new({ case = 'lower' }),
        augend.hexcolor.new({ case = 'upper' }),
      },
      json = {
        augend.semver.alias.semver,
      },
      markdown = {
        augend.misc.alias.markdown_header,
        new({ '[ ]', '[x]' }),
      },
      r = {
        new({ 'TRUE', 'FALSE' }),
        new({ 'fin', 'oza', 'pon' }),
        new({ 'Fingolimod', 'Ozanimod', 'Ponesimod' }),
        new({ 'phip', 'phf6' }),
        new({ 'PHIP', 'PHF6' }),
        new({ 'jurkat', 'pf382' }),
        new({ 'Jurkat', 'PF382' }),
        new({ 'sgID2', 'agx51' }),
        new({ 'SGID2', 'AGX51' }),
      },
      vim = {
        new({ 'echom', 'execute' }),
        -- new({ 'opt', 'start' }),
        -- new({ 'autoload', 'plugin' }),
      },
    }

    -- create rmd group as a combination of markdown and r
    groups.rmd = vim.tbl_extend('force', {}, groups.r, groups.markdown)
    -- PERF: lazyload by creating the groups on FileType events

    for name, _ in pairs(groups) do
      dials_by_ft[name] = name
    end

    -- extend each group with default switches
    for _, group in pairs(groups) do
      vim.list_extend(group, default_switches)
    end

    require('dial.config').augends:register_group(groups)
  end,
  keys = function()
    ---@param increment boolean
    ---@param g? boolean
    local function dial(increment, g)
      local is_visual = vim.tbl_contains({ 'v', 'V', '\22' }, vim.fn.mode(true))

      ---@type "inc_normal"|"dec_normal"|"inc_gvisual"|"dec_visual"
      local fn = string.format(
        '%s%s%s',
        increment and 'inc' or 'dec',
        g and '_g' or '_',
        is_visual and 'visual' or 'normal'
      )
      local group = dials_by_ft[vim.bo.filetype] or 'default'
      return require('dial.map')[fn](group)
    end

    return {
      mode = { 'n', 'v' },
      expr = true,
        -- stylua: ignore start
        {  '<C-a>', function() return dial(true) end        },
        {  '<C-x>', function() return dial(false) end       },
        { 'g<C-a>', function() return dial(true, true) end  },
        { 'g<C-x>', function() return dial(false, true) end },
    }
  end,
}
