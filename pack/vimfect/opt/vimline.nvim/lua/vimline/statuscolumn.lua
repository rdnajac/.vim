local M = {}

-- width of status column
local WIDTH = 3 -- fixed width

M.statuscolumn = function()
  local lnum = vim.v.lnum
  local content = tostring(lnum)

  -- only query signs if buffer is valid
  local bufnr = vim.api.nvim_get_current_buf()
  if bufnr > 0 and vim.api.nvim_buf_is_valid(bufnr) then
    local placed = vim.fn.sign_getplaced(bufnr, { lnum = lnum, group = '*' })
    local signs = (placed[1] and placed[1].signs) or {}
    if #signs > 0 then
      content = signs[1].text or signs[1].name or content
    end
  end

  -- right-align in WIDTH spaces
  content = string.rep(' ', WIDTH - #content) .. content

  -- append the border
  return content .. '│'
end

return setmetatable(M, {
  __call = function()
    return M.statuscolumn()
  end,
})
