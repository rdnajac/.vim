local M = {}

---@module "snacks"
---@class snacks.dashboard.Config
M.config = {
  formats = {
    key = function(item)
      local sep = icons.separators.section.rounded
        -- stylua: ignore
      return {
        { sep.right, hl = 'special' }, { item.key, hl = 'key' }, { sep.left, hl = 'special' }, }
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

return M
