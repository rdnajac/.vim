local M = { 'echasnovski/mini.nvim' }

package.preload['nvim-web-devicons'] = function()
  require('mini.icons').mock_nvim_web_devicons()
  return package.loaded['nvim-web-devicons']
end

M.event = 'BufWinEnter'

M.config = function()
  require('mini.align').setup({})
  -- require('mini.splitjoin').setup({
  --   mappings = {
  --     toggle = 'gS',
  --     split = '',
  --     join = 'gJ',
  --   },
  --
  --   -- Detection options: where split/join should be done
  --   detect = {
  --     -- Array of Lua patterns to detect region with arguments.
  --     -- Default: { '%b()', '%b[]', '%b{}' }
  --     brackets = nil,
  --
  --     -- String Lua pattern defining argument separator
  --     separator = ',',
  --
  --     -- Array of Lua patterns for sub-regions to exclude separators from.
  --     -- Enables correct detection in presence of nested brackets and quotes.
  --     -- Default: { '%b()', '%b[]', '%b{}', '%b""', "%b''" }
  --     exclude_regions = nil,
  --   },
  -- })
  -- vim.defer_fn(function()
    require('meta').module(vim.fn.stdpath('config') .. '/lua/nvim/mini')
  -- end, 0)
end

return M
