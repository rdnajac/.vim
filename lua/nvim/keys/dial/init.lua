-- second,second,third
local SELECT = [[lua require('dial.command').select_augend_%s(%s)]]
local TXTOBJ = [[lua require('dial.command').textobj()]]
local OPFUNC = [[let &opfunc='dial#operator#%s_%s']]
-- calls: lua require("dial.command").operator_%s("decrement", true)

local function cmdcr(s) return string.format('<Cmd>%s<CR>', s) end
local function cmd(direction, mode, group)
  -- local group_arg = group and vim.fn.string(group) or ''
  local select = string.format(SELECT, mode, group)
  local setop = string.format(OPFUNC, direction, mode)
  local textobj = (mode == 'normal' or mode == 'gnormal') and TXTOBJ or ''
  return vim.v.count1 .. cmdcr(select) .. cmdcr(setop) .. 'g@' .. cmdcr(textobj)
end

local visual_modes = { v = true, V = true, ['\22'] = true }
local is_visual = function() return visual_modes[vim.fn.mode(true)] end
local _mode = function() return is_visual() and 'visual' or 'normal' end


-- ---@param increment boolean
-- ---@param g? boolean
-- local function dial(increment, g)
--   local mode = (g and 'g' or '') .. _mode()
--   local direction = increment and 'increment' or 'decrement'
-- local function increment() return dial(true) end
-- local function gincrement() return dial(true, true) end
-- local function decrement() return dial(false) end
-- local function gdecrement() return dial(false, true) end
--
---@param increment boolean
---@param g? boolean
local function dial(increment, g)
  local mode = (g and 'g' or '') .. _mode()
  local direction = increment and 'increment' or 'decrement'
  vim.cmd.normal({ vim.keycode(cmd(direction, mode)), bang = true })
end

local keymaps = {
  ['<C-a>'] = { inc = true },
  ['<C-x>'] = { inc = false },
  ['g<C-a>'] = { inc = true, g = true },
  ['g<C-x>'] = { inc = false, g = true },
}

for lhs, spec in pairs(keymaps) do
  vim.keymap.set({ 'n', 'x' }, lhs, function() dial(spec.inc, spec.g) end)
end

-- local keys = {
--   { {'n', 'x'}, '<C-a>, require('nvim.keys.dial').
--   { {'n', 'x'}, '<C-x>' },
--   { {'n', 'x'}, 'g<C-a>' },
--   { {'n', 'x'}, 'g<C-x>' }
--
-- return {
