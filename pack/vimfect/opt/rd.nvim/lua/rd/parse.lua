local M = {}
local modes = { 'n', 'v', 'x', 'i', 't', 'o', 'c', 's' }
local function has_mode(t) return type(t[1]) == 'table' or vim.tbl_contains(modes, t[1]) end

-- TODO: if table has `ft` or `lsp` keys, use `Snacks.keymap.set()`
--- Converts a variety of table formats into `vim.keymap.set` opts
---@param t table
---@return string|table mode, string lhs,string|fun() rhs, table opts
function M.keys(t)
  -- stylua: ignore
  ---@diagnostic disable-next-line: redundant-return-value
  if has_mode(t) then return unpack(t) end
  dd(t)
  local lhs, rhs, opts = t[1], t[2], t[3]
  opts = type(opts) == 'table' and opts or {}
  for k, v in pairs(t) do
    if type(k) == 'string' and k ~= 'mode' then
      opts[k] = v
    end
  end
  return t.mode or 'n', lhs, rhs, opts
end

return M
