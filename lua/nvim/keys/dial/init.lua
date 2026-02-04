local SELECT = [[lua require('dial.command').select_cugend_%s(%s)]]
local TXTOBJ = [[lua require('dial.command').textobj()]]
local OPFUNC = [[let &opfunc='dial#operator#%s_%s']]
-- calls: lua require("dial.command").operator_%s("decrement", true)

local function cmdcr(s) return string.format('<Cmd>%s<CR>', s) end
-- local function cmdcr(s) return return '<Cmd>' .. s .. '<CR>' end

local visual_modes = { v = true, V = true, ['\22'] = true }
local is_visual = function() return visual_modes[vim.fn.mode(true)] end

local function cmd(direction, mode, group)
  local select = string.format(SELECT, mode, group)
  local setop = string.format(OPFUNC, direction, mode)
  local textobj = (mode == 'normal' or mode == 'gnormal') and TXTOBJ or ''
  return vim.v.count1 .. cmdcr(select) .. cmdcr(setop) .. 'g@' .. cmdcr(textobj)
end

---@param increment boolean
---@param g? boolean
local function dial(increment, g)
  local mode = (g and 'g' or '') .. (is_visual() and 'visual' or 'normal')
  local direction = increment and 'increment' or 'decrement'

  local keys = vim.keycode(cmd(direction, mode, group))

  vim.cmd.normal({ keys, bang = true })
  -- vim.api.nvim_feedkeys(keys, 'n', false)
end

return dial
