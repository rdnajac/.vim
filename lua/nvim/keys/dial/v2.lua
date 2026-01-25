local dial = require('dial.command')
local feedkeys = vim.api.nvim_feedkeys
local keycode = vim.keycode

local visual_modes = {
  v = true,
  V = true,
  ['\22'] = true,
}

local SELECT = {
  normal  = function(group) return 'lua require("dial.command").select_augend_normal(' .. group .. ')' end,
  gnormal = function(group) return 'lua require("dial.command").select_augend_gnormal(' .. group .. ')' end,
  visual  = function(group) return 'lua require("dial.command").select_augend_visual(' .. group .. ')' end,
  gvisual = function(group) return 'lua require("dial.command").select_augend_gvisual(' .. group .. ')' end,
}

local OPFUNC = {
  normal  = { increment = 'let &opfunc="dial#operator#increment_normal"',  decrement = 'let &opfunc="dial#operator#decrement_normal"'  },
  gnormal = { increment = 'let &opfunc="dial#operator#increment_gnormal"', decrement = 'let &opfunc="dial#operator#decrement_gnormal"' },
  visual  = { increment = 'let &opfunc="dial#operator#increment_visual"',  decrement = 'let &opfunc="dial#operator#decrement_visual"'  },
  gvisual = { increment = 'let &opfunc="dial#operator#decrement_gvisual"', decrement = 'let &opfunc="dial#operator#decrement_gvisual"' },
}

local TXTOBJ = {
  normal = 'lua require("dial.command").textobj()',
  gnormal = 'lua require("dial.command").textobj()',
}

local function cmdcr(s)
  return '<Cmd>' .. s .. '<CR>'
end

local function build_keys(direction, mode, group)
  local keys = vim.v.count1
    .. cmdcr(SELECT[mode](group))
    .. cmdcr(OPFUNC[mode][direction])
    .. 'g@'

  local textobj = TXTOBJ[mode]
  if textobj then
    keys = keys .. cmdcr(textobj)
  end

  return keycode(keys)
end

local M = {}

function M.dial(increment, g)
  local is_visual = visual_modes[vim.fn.mode(true)]
  local mode = (g and 'g' or '') .. (is_visual and 'visual' or 'normal')
  local direction = increment and 'increment' or 'decrement'
  local group = dials_by_ft[vim.bo.filetype] or 'default'

  feedkeys(build_keys(direction, mode, group), 'n', false)
end

local keymaps = {
  ['<C-a>']   = { inc = true },
  ['<C-x>']   = { inc = false },
  ['g<C-a>']  = { inc = true,  g = true },
  ['g<C-x>']  = { inc = false, g = true },
}

for lhs, spec in pairs(keymaps) do
  vim.keymap.set({ 'n', 'x' }, lhs, function()
    M.dial(spec.inc, spec.g)
  end)
end

return M
