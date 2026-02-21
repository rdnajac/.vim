local M = {
  active = function()
    local render = require('nvim.ui.status').render
    return render(' %t')
  end,

  inactive = function()
    -- return '%t'
    return '%t'
  end,
}

setmetatable(M, {
  __call = function()
    if vim.bo.filetype == 'snacks_dashboard' then
      return ''
    end
    local active = vim.fn['vimline#active#winbar']() == 1
    if active then
      return M.active()
    else
      return M.inactive()
    end
  end,
})
return M
