local M = {}

M.clock = {
  {
    function()
      return '  ' .. os.date('%T')
    end,
    separator = { left = ' ' },
  },
}

M.date = {
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

return M
