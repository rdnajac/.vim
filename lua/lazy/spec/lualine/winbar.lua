local M = {}

local date = {
  function()
    return ' ' .. os.date('%F')
  end,
  color = { gui = 'reverse,bold' },
  -- HACK: force this component to always be on the top right window
  cond = function()
    local winid = vim.api.nvim_get_current_win()
    local current_pos = vim.fn.win_screenpos(winid)
    for _, id in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      if id ~= winid then
        local pos = vim.fn.win_screenpos(id)
        if pos[1] < current_pos[1] or (pos[1] == current_pos[1] and pos[2] > current_pos[2]) then
          return false
        end
      end
    end
    return true
  end,
}

M.active = {
  lualine_a = {
    {
      'diagnostics',
      symbols = LazyVim.config.icons.diagnostics,
      always_visible = true,
      color = { bg = '#3b4261' },
      separator = { right = '🭛' },
    },
  },
  lualine_b = { require('lazy.spec.lualine.components.navic') },
  lualine_z = { date },
}

M.inactive = {
  lualine_a = {
    {
      function()
        local icon = ''
        local ok, devicons = pcall(require, 'nvim-web-devicons')
        if ok then
          icon = devicons.get_icon(vim.fn.expand('%:t'), nil, { default = true })
            or devicons.get_icon_by_filetype(vim.bo.filetype, { default = true })
            or ''
        end
        return icon
      end,
    },
    { 'filename', separator = { right = '🭛' } },
  },
  lualine_z = { date },
}

return M
