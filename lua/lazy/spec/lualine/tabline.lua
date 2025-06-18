return {
  lualine_a = { require('lazy.spec.lualine.components.path').prefix },
  lualine_b = {
    require('lazy.spec.lualine.components.path').suffix,
    require('lazy.spec.lualine.components.path').modified,
  },
  -- lualine_c = {},
  lualine_x = {},
  lualine_y = {
    {
      function()
        if require('lazy.status').has_updates() then
          return require('lazy.status').updates() .. ' 󰒲 '
        end
        return ''
      end,
      cond = require('lazy.status').has_updates,
    },
  },
  lualine_z = {
    {
      function()
        return '   ' .. os.date('%F')
      end,
      color = { gui = 'reverse,bold' },
    },
    {
      function()
        return '   ' .. os.date('%T')
      end,
      color = { gui = 'reverse,bold' },
    },
  },
}
