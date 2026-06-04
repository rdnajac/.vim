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

local fn = vim.fn

-- https://github.com/neovim/neovim/discussions/38271#discussion-9630986
M.get_visual = function()
  local vis_mode = fn.mode():match('[Vv\22]')
  if not vis_mode then
    return
  end
  local line_regs = fn.getregionpos(fn.getpos('v'), fn.getpos('.'), {
    type = vis_mode,
    eol = true,
    exclusive = false,
  })
  local sel_text = {}
  for _, reg in ipairs(line_regs) do
    local r1, c1, r2, c2 = reg[1][2], reg[1][3], reg[2][2], reg[2][3]
    local buf_text = vim.api.nvim_buf_get_text(0, r1 - 1, c1 - 1, r2 - 1, c2, {})
    vim.list_extend(sel_text, buf_text)
  end
  return sel_text, line_regs
end

return M
