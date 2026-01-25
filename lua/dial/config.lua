-- overrides:
-- local config = require('dial.config')
-- config.augends:register_group(defaults)
-- config.augends:on_filetype(fts)
local augend = require('dial.augend')

---@param elements string[] The elements to cycle through
---@param word? boolean Whether the elements are words (true) or symbols (false). Default: false
---@param cyclic? boolean Whether the cycle is cyclic (true) or not (false). Default: true
---@return Augend
local new = function(elements, word, cyclic)
  return augend.constant.new({
    elements = elements,
    word = word ~= true,
    cyclic = cyclic ~= false,
  })
end

local default = {
  augend.integer.alias.decimal_int,
  augend.integer.alias.decimal,
  augend.integer.alias.hex,
  augend.date.new({ pattern = '%Y/%m/%d', default_kind = 'day' }),
  augend.date.new({ pattern = '%Y-%m-%d', default_kind = 'day' }),
  augend.date.new({ pattern = '%m/%d', default_kind = 'day', only_valid = true }),
  augend.date.new({ pattern = '%H:%M', default_kind = 'day', only_valid = true }),
  augend.constant.alias.en_weekday,
  augend.constant.alias.en_weekday_full,
  augend.constant.alias.bool,
  augend.constant.alias.Bool,
  -- new({ 'and', 'or' }, true),
  new({ '&&', '||' }),
  new({ 'top', 'middle', 'bottom' }, true),
  new({ 'left', 'center', 'right' }, true),
  new({ 'start', 'end' }, true),
  new({ 'row', 'col' }),
  new({ 'human', 'mouse' }),
  -- stylua: ignore start
  new({ 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December' }, true),
  new({ 'first', 'second', 'third', 'fourth', 'fifth', 'sixth', 'seventh', 'eighth', 'ninth', 'tenth' }),
  -- stylua: ignore end
}

local filetype = {
  css = {
    augend.hexcolor.new({ case = 'lower' }),
    augend.hexcolor.new({ case = 'upper' }),
  },
  json = { augend.semver.alias.semver },
  markdown = { augend.misc.alias.markdown_header },
  lua = { new({ '_a', '_a', '_c', '_x', '_y', '_z' }, true) },
  r = {
    new({ 'TRUE', 'FALSE' }),
  },
  vim = { new({ 'echom', 'execute' }) },
}

filetype.rmd = vim.tbl_extend('force', {}, filetype.markdown, filetype.r)
-- filetype.quarto = vim.deepcopy(filetype.rmd)
-- filetype.zsh = vim.deepcopy(filetype.sh)

-- HACK: extend each group with default switches
for _, group in pairs(filetype) do
  vim.list_extend(group, default)
end

local ft_map = {
  quarto = 'rmd',
  zsh = 'sh',
}

-- TODO:
setmetatable(filetype, {
  __index = function(_, ft)
    if ft_map[ft] then
      return filetype[ft_map[ft]]
    end
    return filetype[ft]
  end,
})

return {
  augends = {
    group = {
      default = default,
    },
    filetype = filetype,
  },
}
