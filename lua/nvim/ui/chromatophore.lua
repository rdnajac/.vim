local get_mode = require('nvim.mode').get_mode

    ---@type table<string, string>
    _G.ModeColor = {
      normal = '#9ece6a',
      insert = '#14aeff',
      visual = '#f7768e',
      replace = '#ff007c',
      command = '#39ff14',
      terminal = '#BB9AF7',
      pending = '#39ff14',
    }
    ---@type table<string, string>
    _G.ModeLowerKey = setmetatable({
      NORMAL = 'normal',
      INSERT = 'insert',
      VISUAL = 'visual',
      ['V-LINE'] = 'visual',
      ['V-BLOCK'] = 'visual',
      SELECT = 'visual',
      ['S-LINE'] = 'visual',
      ['S-BLOCK'] = 'visual',
      REPLACE = 'replace',
      ['V-REPLACE'] = 'replace',
      COMMAND = 'command',
      EX = 'command',
      CONFIRM = 'command',
      SHELL = 'shell',
      TERMINAL = 'terminal',
      O_PENDING = 'pending',
      MORE = 'more',
    }, {
      __index = function()
        return 'normal'
      end,
    })

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

