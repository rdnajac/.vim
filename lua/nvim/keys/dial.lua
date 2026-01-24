---Sandwich input string between <Cmd> and <CR>.
---@param body string
local function cmdcr(body)
  local cmd_sequences = '<Cmd>'
  local cr_sequences = '<CR>'
  return cmd_sequences .. body .. cr_sequences
end


---Output command sequence which provides dial operation.
---@param direction direction
---@param mode mode
---@param group? string
---@param count? integer
local function _cmd_sequence(direction, mode, group, count)
  local select
  if group == nil then
    select = cmdcr([[lua require"dial.command".select_augend_]] .. mode .. '()')
  else
    select = cmdcr(
      [[lua require"dial.command".select_augend_]] .. mode .. [[(]] .. vim.fn.string(group) .. [[)]]
    )
  end
  -- command.select_augend_normal(vim.v.count, group)
  local setopfunc = cmdcr([[let &opfunc="dial#operator#]] .. direction .. '_' .. mode .. [["]])
  local textobj = (mode == 'normal' or mode == 'gnormal') and cmdcr([[lua require("dial.command").textobj()]]) or ''

  if count ~= nil then
    if type(count) ~= 'number' then
      error('count must be a integer.')
    end
    return count .. select .. setopfunc .. 'g@' .. textobj
  end
  return select .. setopfunc .. 'g@' .. textobj
end

---Functional interface
---@param direction direction
---@param mode mode
---@param group? string
---@param count? integer
local function manipulate(direction, mode, group, count)
  if count == nil then
    count = vim.v.count1
  end
  vim.cmd.normal({
    vim.api.nvim_replace_termcodes(_cmd_sequence(direction, mode, group, count), true, true, true),
    bang = true,
  })
end

require('dial.map').manipulate('increment', 'gvisual')
local map = {
  inc_normal = function(group) return _cmd_sequence('increment', 'normal', group) end,
  dec_normal = function(group) return _cmd_sequence('decrement', 'normal', group) end,
  inc_gnormal = function(group) return _cmd_sequence('increment', 'gnormal', group) end,
  dec_gnormal = function(group) return _cmd_sequence('decrement', 'gnormal', group) end,
  inc_visual = function(group) return _cmd_sequence('increment', 'visual', group) end,
  dec_visual = function(group) return _cmd_sequence('decrement', 'visual', group) end,
  inc_gvisual = function(group) return _cmd_sequence('increment', 'gvisual', group) end,
  dec_gvisual = function(group) return _cmd_sequence('decrement', 'gvisual', group) end,
}

local M = {}

local dials_by_ft = {
  quarto = 'rmd',
  zsh = 'sh',
}

---@param increment boolean
---@param g? boolean
M.dial = function(increment, g)
  local is_visual = vim.tbl_contains({ 'v', 'V', '\22' }, vim.fn.mode(true))

  ---@type "inc_normal"|"dec_normal"|"inc_gvisual"|"dec_visual"
  local fn = string.format(
    '%s%s%s',
    increment and 'inc' or 'dec',
    g and '_g' or '_',
    is_visual and 'visual' or 'normal'
  )
  local group = dials_by_ft[vim.bo.filetype] or 'default'
  -- XXX: 
  -- return require('dial.map')[fn](group)
  return map[fn](group)
end

for k, v in pairs({
  ['<C-a>'] = function() return M.dial(true) end,
  ['<C-x>'] = function() return M.dial(false) end,
  ['g<C-a>'] = function() return M.dial(true, true) end,
  ['g<C-x>'] = function() return M.dial(false, true) end,
}) do
  vim.keymap.set('n', k, v, { expr = true })
  vim.keymap.set('x', k, v, { expr = true })
end

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

local default_switches = {
  augend.integer.alias.decimal,
  augend.integer.alias.decimal_int,
  augend.integer.alias.hex,
  augend.date.alias['%Y/%m/%d'],
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
    -- FIXME: doesn't work
    new({ '[ ]', '[x]' }),
  },
  lua = {
    new({ '_a', '_b', '_c' }, true),
    new({ '_x', '_y', '_z' }, true),
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

for name, _ in pairs(groups) do
  dials_by_ft[name] = name
end

-- extend each group with default switches
for _, group in pairs(groups) do
  vim.list_extend(group, default_switches)
end

require('dial.config').augends:register_group(groups)

return setmetatable(M, {
  __call = function(M, ...) return M.dial(...) end,
})
