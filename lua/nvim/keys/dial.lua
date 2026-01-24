local SELECT_FMT = '<Cmd>lua require"dial.command".select_augend_%s(%s)<CR>'
local SETOP_FMT = '<Cmd>let &opfunc="dial#operator#%s_%s"<CR>'
local TEXTOBJ = '<Cmd>lua require("dial.command").textobj()<CR>'

local function cmd(direction, mode, group, count)
  if count ~= nil and type(count) ~= 'number' then
    error('count must be a integer.')
  end

  local group_arg = group and vim.fn.string(group) or ''
  local prefix = tostring(count or '')

  local select = string.format(SELECT_FMT, mode, group_arg)
  local setop = string.format(SETOP_FMT, direction, mode)
  local textobj = (mode == 'normal' or mode == 'gnormal') and TEXTOBJ or ''

  return prefix .. select .. setop .. 'g@' .. textobj
end

local function manipulate(direction, mode, group, count)
  vim.cmd.normal({
    vim.keycode(cmd(direction, mode, group, count or vim.v.count1)),
    bang = true,
  })
end

local M = {}

local dials_by_ft = {
  quarto = 'rmd',
  zsh = 'sh',
}

local visual_modes = { v = true, V = true, ['\22'] = true }

---@param increment boolean
---@param g? boolean
function M.dial(increment, g)
  local is_visual = visual_modes[vim.fn.mode(true)]
  local mode = (g and 'g' or '') .. (is_visual and 'visual' or 'normal')
  local direction = increment and 'increment' or 'decrement'
  local group = dials_by_ft[vim.bo.filetype] or 'default'

  manipulate(direction, mode, group)
end

local keymaps = {
  ['<C-a>'] = { inc = true },
  ['<C-x>'] = { inc = false },
  ['g<C-a>'] = { inc = true, g = true },
  ['g<C-x>'] = { inc = false, g = true },
}

for lhs, spec in pairs(keymaps) do
  vim.keymap.set({ 'n', 'x' }, lhs, function() M.dial(spec.inc, spec.g) end)
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
  json = { augend.semver.alias.semver },
  markdown = { augend.misc.alias.markdown_header },
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

-- setmetatable(M, {
--   __call = function(M, ...) return M.dial(...) end,
-- })
return M
