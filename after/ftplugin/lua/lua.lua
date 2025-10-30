-- TODO: only disable highlighting inside of `vim.cmd([[...]])`
-- Snacks.util.set_hl({ LspReferenceText = { link = 'NONE' } })

-- -- TODO: use `--search-parent-directories` or detect root lua
-- vim.bo.formatprg = 'stylua --stdin-filepath='
--     .. vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':p')
--     .. ' -f '
--     .. vim.fs.joinpath(vim.fn.stdpath('config'), 'stylua.toml')

-- Keep using legacy syntax for `vim-endwise`
vim.bo.syntax = 'ON'

vim.cmd([[
 setlocal nonumber signcolumn=yes:1
 setlocal foldtext=v:lua.nv.foldtext()
]])

_G.nv.foldtext = function()
  local foldstart = vim.v.foldstart
  local start_line = vim.fn.getline(foldstart)
  local next_line = vim.fn.getline(foldstart + 1)

  if start_line:match('{%s*$') then
    -- fold start ends with `{` (possibly followed by spaces)
    return start_line .. next_line
  end

  if vim.fn.indent(foldstart + 1) > vim.fn.indent(foldstart) then
    return next_line
  end

  return start_line
end
