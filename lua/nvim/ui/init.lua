--- Window types each have respective filetype
--- • `msg`: messages when 'cmdheight' == 0.
--- • `pager`: used for |:messages| and certain messages that should be shown in full
--- • `dialog`: used for prompt messages that expect user input
local ui_fts = { 'msg', 'pager' }
-- apply markdown highlighting to message windows
vim.treesitter.language.register('markdown', ui_fts)
vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = ui_fts,
  -- group = 'nv.treesitter',
  callback = function(ev)
    vim.treesitter.start(0)
    vim.wo.conceallevel = 3
    vim.keymap.set({ 'n' }, 'gf', nv.fs.better_gf, { buf = ev.buf })
  end,
  desc = 'Start tree-sitter for message windows',
})

local M = {
  colorscheme = require('nvim.ui.tokyonight'),
  icons = require('nvim.ui.icons'),
  status = require('nvim.ui.status'),
  winbar = require('nvim.ui.winbar'),
}

vim.schedule(function()
  vim.o.statusline = [[%{%v:lua.nv.ui.status.line()%}]]
  vim.o.winbar = [[%{%v:lua.nv.ui.winbar()%}]]
end)

function M.spinner()
  local spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
  return spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
end

--- foldtext for lua files with treesitter folds
---@return string
M.foldtext = function()
  local start = vim.fn.getline(vim.v.foldstart)
  if not vim.list_contains({ '{', '(', '[', 'then', 'do' }, vim.trim(start):sub(-1)) then
    return start -- return if no special handling
  end
  if vim.trim(start) == '{' then -- only '{' on the line
    local second_line = vim.fn.getline(vim.v.foldstart + 1)
    local quoted_str = second_line:match('^%s*(["\']..-["\'],?)%s*$')
    start = start .. ' ' .. quoted_str
  end
  return ('%s...%s'):format(start, vim.trim(vim.fn.getline(vim.v.foldend)))
end

return M
