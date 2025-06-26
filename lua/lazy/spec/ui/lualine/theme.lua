-- Override lualine's highlight group generator with fixed chromatophore name
-- package.preload['lualine.highlight'] = function()
--   local mod = dofile(vim.api.nvim_get_runtime_file('lua/lualine/highlight.lua', false)[1])
--   mod.create_component_highlight_group = function(_, _, options, _)
--     return {
--       name = 'lualine_' .. options.self.section .. '_chromatophore',
--       fn = nil,
--       no_mode = true,
--       link = false,
--       section = options.self.section,
--       options = options,
--       no_default = true,
--     }
--   end
--   return mod
-- end

local get_mode = require('lazy.spec.ui.lualine.mode').get_mode

---@return string
function _G.current_mode_color()
  return _G.ModeColor[_G.ModeLowerKey[get_mode()]]
end

local visual_modes = { 'v', 'V', '\22' }

local update_chromatophore_base = function()
  local mode_color = _G.current_mode_color()
  local black = '#000000'
  local grey = '#3b4261'
  Snacks.util.set_hl({
    ChromatophoreBase = { fg = mode_color, bg = 'NONE' },
    String = { link = 'ChromatophoreBase' },
    -- MsgArea = { link = 'ChromatophoreBase' },
    lualine_a_chromatophore = { fg = black, bg = mode_color, bold = true },
    lualine_ab_chromatophore = { fg = mode_color, bg = grey },
    lualine_b_chromatophore = { fg = mode_color, bg = grey, bold = true },
    lualine_c_chromatophore = { fg = mode_color, bg = 'NONE' },
    lualine_x_chromatophore = { fg = mode_color, bg = 'NONE' },
    lualine_y_chromatophore = { bg = mode_color, fg = 'NONE' },
    lualine_z_chromatophore = { fg = mode_color, bg = 'NONE' },
    StatusLine = { link = 'lualine_b_chromatophore' },
  }, { default = false })

  Snacks.util.winhl({ String = 'String' })
  Snacks.util.winhl({ StatusLine = 'StatusLine' })
end

update_chromatophore_base()

vim.api.nvim_create_autocmd('ModeChanged', {
  callback = function()
    if not vim.tbl_contains(visual_modes, vim.fn.mode()) then
      update_chromatophore_base()
    end
  end,
})

for _, key in ipairs(visual_modes) do
  Snacks.util.on_key(key, function()
    if vim.tbl_contains(visual_modes, vim.fn.mode()) then
      update_chromatophore_base()
    end
  end)
end

-- vim.api.nvim_create_autocmd('CmdlineEnter', {
--   group = vim.api.nvim_create_augroup('LualineChromatophore', { clear = true }),
--   callback = function()
--     vim.api.nvim_set_hl(0, 'Normal', { link = 'lualine_b_chromatophore' })
--   end,
-- })
--
-- vim.api.nvim_create_autocmd('CmdlineLeave', {
--   group = 'LualineChromatophore',
--   callback = function()
--     vim.api.nvim_set_hl(0, 'Normal', { fg = '#c0caf5', bg = 'NONE' })
--   end,
-- })

-- return dummy theme
return {
  normal = {
    a = { fg = 'NONE' },
    b = { fg = 'NONE' },
    c = { fg = 'NONE' },
    x = { fg = 'NONE' },
    y = { fg = 'NONE' },
    z = { fg = 'NONE' },
  },
}
