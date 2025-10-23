---@module "snacks"
---@class snacks.dashboard.Config
return {
  sections = {
    { section = 'header' },
    -- { section = 'recent_files', limit = 5, indent = 2 },
    {
      section = 'terminal',
      cmd = '$HOME/.vim/bin/cowsay-vim-fortunes #' .. os.time(),
      -- cmd = '~/.vim/etc/learn-something | cowsay #' .. os.time(),
      padding = 1 ,
    },
    { padding = 1 },
  },
  formats = {
    -- header = { '%s', align = 'center', hl = 'Chromatophore' },
    header = { '%s',  hl = 'Chromatophore' },
    key = function(item)
      return { item.key, hl = 'Chromatophore' }
    end,
    --   file = function(item, ctx)
    --     local fname = vim.fn.fnamemodify(item.file, ':~')
    --     fname = ctx.width and #fname > ctx.width and vim.fn.pathshorten(fname) or fname
    --
    --     if #fname > ctx.width then
    --       local dir = vim.fn.fnamemodify(fname, ':h')
    --       local file = vim.fn.fnamemodify(fname, ':t')
    --       if dir and file then
    --         file = file:sub(-(ctx.width - #dir - 2))
    --         fname = dir .. '/…' .. file
    --       end
    --     end
    --
    --     local dir, file = fname:match('^(.*)/(.+)$')
    --     local display_str = dir and (dir .. '/' .. file) or file
    --     local n_dots = math.max(1, ctx.width - #display_str - #(item.key or ''))
    --     local ret = {
    --       { file, hl = 'Chromatophore' },
    --       { string.rep('.', n_dots), hl = 'Comment' },
    --     }
    --
    --     if dir then
    --       table.insert(ret, 1, { dir .. '/', hl = 'dir' })
    --     end
    --     return ret
    --   end,
  },
  wo = { winbar = '', winhighlight = { 'WinBar:NONE' } },
}
