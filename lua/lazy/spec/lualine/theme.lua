-- Override lualine's highlight group generator with fixed chromatophore name
package.preload['lualine.highlight'] = function()
  local mod = dofile(vim.api.nvim_get_runtime_file('lua/lualine/highlight.lua', false)[1])
  mod.create_component_highlight_group = function(_, _, options, _)
    return {
      name = 'lualine_' .. options.self.section .. '_chromatophore',
      fn = nil,
      no_mode = true,
      link = false,
      section = options.self.section,
      options = options,
      no_default = true,
    }
  end
  return mod
end

---@return string
function _G.current_mode_key()
  return _G.ModeLowerKey[require('lualine.utils.mode').get_mode()]
end

---@return string
function _G.current_mode_color()
  return _G.ModeColor[_G.ModeLowerKey[require('lualine.utils.mode').get_mode()]]
end

local visual_modes = { 'v', 'V', '\22' }

local update_chromatophore_base = function()
  local mode_color = _G.current_mode_color()
  local black = '#000000'
  local grey = '#3b4261'
  Snacks.util.set_hl({
    ChromatophoreBase = { fg = mode_color, bg = 'NONE' },
    String = { link = 'ChromatophoreBase' },
    lualine_a_chromatophore = { fg = black, bg = mode_color, bold = true },
    lualine_b_chromatophore = { fg = mode_color, bg = grey, bold = true },
    lualine_c_chromatophore = { fg = mode_color, bg = 'NONE' },
    lualine_x_chromatophore = { fg = mode_color, bg = 'NONE' },
    lualine_y_chromatophore = { bg = mode_color, fg = 'NONE' },
    lualine_z_chromatophore = { fg = mode_color, bg = 'NONE' },
  }, { default = false })

  Snacks.util.winhl({ String = 'String' })
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
