-- overrides: $PACKDIR/dial.nvim/lua/dial/config.lua
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

local M = {
  augends = {
    group = {
      default = {
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
        new({ 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec' }, true),
        new({ 'January', 'February', 'March', 'April', 'May', 'June', 'July',
	      'August', 'September', 'October', 'November', 'December' }, true),
        new({ 'first', 'second', 'third', 'fourth', 'fifth', 'sixth', 'seventh',
	      'eighth', 'ninth', 'tenth', 'eleventh', 'twelfth', 'thirteenth' }),
        -- stylua: ignore end
      },
    },
  },
}

local filetype = {
  css = {
    augend.hexcolor.new({ case = 'lower' }),
    augend.hexcolor.new({ case = 'upper' }),
  },
  json = { augend.semver.alias.semver },
  markdown = { augend.misc.alias.markdown_header },
  lua = {
    new({ '_a', '_a', '_c', '_x', '_y', '_z' }, true),
    -- TODO: require('module.submodule.key') to require('module.submodule').key
    -- incerment and decrement like  and  and reach require('module').submodule.key
  },
  r = {
    new({ 'TRUE', 'FALSE' }),
  },
  sh = {
    new({ 'bash', 'sh', 'zsh' }),
  },
  vim = {
    new({ 'echom', 'execute' }),
  },
  -- filetype mappings
  quarto = 'rmd',
  sass = 'css',
  scss = 'css',
  zsh = 'sh',
}

-- combine filetypes
filetype.rmd = vim.tbl_extend('force', {}, filetype.markdown, filetype.r)

M.augends.filetype = setmetatable({}, {
  __index = function(t, ft)
    local v = rawget(filetype, ft)
    local res

    if type(v) == 'string' then
      -- only follow one level of redirection
      if type(rawget(filetype, v)) == 'string' then
        error(('too many levels of redirection: %s = %s'):format(ft, v))
      end
      res = t[v] -- redirect and re-trigger __index
    elseif type(v) == 'table' then
      -- create a copy and extend with defaults on first access
      res = vim.list_extend(vim.deepcopy(v), M.augends.group.default)
    end

    rawset(t, ft, res)
    return res
  end,
})

return M
