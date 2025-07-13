local M = {}

---@module "snacks"
---@class snacks.dashboard.Config
M.config = {
  preset = {
    keys = {
      { icon = ' ', title = 'Recent Files', section = 'recent_files', indent = 2, gap = 0 },
      { icon = ' ', key = 'g', desc = 'Lazygit', action = ':Lazygit' },
      { icon = '󱌣 ', key = 'm', desc = 'Mason', action = ':Mason' },
      { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
    },
  },
  sections = {
    { section = 'header', highlight = 'Chromatophore' },
    { section = 'keys' },
    {
      section = 'terminal',
      -- width = 69,
      cmd = '~/.vim/scripts/da.sh',
      height = 13,
    },
  },
  formats = {
    key = function(item)
      local sep = require('nvim.ui.icons').separators.section.rounded
      -- local sep = LazyVim.config.separators.section.rounded
      return {
        { sep.right, hl = 'special' },
        { item.key, hl = 'key' },
        { sep.left, hl = 'special' },
      }
    end,
    file = function(item, ctx)
      local fname = vim.fn.fnamemodify(item.file, ':~')
      fname = ctx.width and #fname > ctx.width and vim.fn.pathshorten(fname) or fname
      if #fname > ctx.width then
        local dir = vim.fn.fnamemodify(fname, ':h')
        local file = vim.fn.fnamemodify(fname, ':t')
        if dir and file then
          file = file:sub(-(ctx.width - #dir - 2))
          fname = dir .. '/…' .. file
        end
      end
      local dir, file = fname:match('^(.*)/(.+)$')
      return dir and { { dir .. '/', hl = 'dir' }, { file, hl = 'file' } } or { { fname, hl = 'file' } }
    end,
  },
}

-- Snacks.config.style('dashboard', { wo = { border = false } })

-- local aug = vim.api.nvim_create_augroup('SnacksDashboardToggle', { clear = true })
-- vim.api.nvim_create_autocmd('User', {
--   group   = aug,
--   pattern = 'SnacksDashboardOpened',
--   once    = true,
--   callback = function()
--     local orig_border     = vim.o.winborder
--     local orig_laststatus = vim.o.laststatus
--
--     vim.g._saved_winborder    = orig_border
--     vim.g._saved_laststatus   = orig_laststatus
--     vim.o.winborder           = 'none'
--     vim.o.laststatus          = 0
--
--     local buf = vim.api.nvim_get_current_buf()
--     vim.api.nvim_create_autocmd({'BufUnload','BufWipeout'}, {
--       group   = aug,
--       buffer  = buf,
--       once    = true,
--       callback = function()
--         vim.o.winborder  = vim.g._saved_winborder
--         vim.o.laststatus = vim.g._saved_laststatus
--         vim.g._saved_winborder  = nil
--         vim.g._saved_laststatus = nil
--       end,
--     })
--   end,
-- })
--

vim.api.nvim_create_autocmd('User', {
  pattern = 'SnacksDashboardOpened',
  once = true,
  callback = function()
    vim.opt.winborder = 'rounded'
  end,
})

return M
