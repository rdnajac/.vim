local M = {}

---@module "snacks"
---@class snacks.dashboard.Config
M.config = {
  sections = {
    -- { section = 'header', highlight = 'Chromatophore' },
    { section = 'header' },
    { section = 'recent_files' },
    { padding = 1 },
    {
      section = 'terminal',
      -- TODO get `gf` to work with variable expansions
      cmd = vim.fn.stdpath('config') .. '/bin/cowsay-vim-fortunes',
      height = 13,
    },
  },
  formats = {
    key = function(item)
      local sep = require('util.icons').separators.section.rounded
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

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'snacks_dashboard',
  callback = function()
    local old_winborder = vim.o.winborder
    if old_winborder ~= 'none' then
      vim.o.winborder = 'none'
      vim.api.nvim_create_autocmd('User', {
        pattern = 'SnacksDashboardClosed',
        -- pattern = 'VimEnter',
        once = true,
        callback = function()
          vim.o.winborder = old_winborder
        end,
      })
      vim.opt.lazyredraw = true
      vim.schedule(function()
        Snacks.dashboard.update()
        vim.opt.lazyredraw = false
      end)
    end
  end,
})

return M
