local M = require('lualine.component'):extend()

  local maxcount = 999,
  timeout = 500,
}

-- Initializer
function M:init(options)
  -- Run super()
  M.super.init(self, options)
  -- Apply default options
  self.options = vim.tbl_extend('keep', self.options or {}, default_options)
end

-- Function that runs every time statusline is updated

return M
