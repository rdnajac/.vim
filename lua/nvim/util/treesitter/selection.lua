--- @type TSNode[]
local nodes = {}
local skip = false

local function select_node(node)
  if node then
    local sr, sc, er, ec = node:range()
    vim.fn.setpos("'<", { 0, sr + 1, sc + 1, 0 })
    vim.fn.setpos("'>", { 0, er + 1, ec, 0 })
    vim.cmd('normal! gv')
  end
end

local function insert_and_select(node)
  if node then
    table.insert(nodes, node)
    select_node(node)
  end
end

local function pget_node()
  local ok, node = pcall(vim.treesitter.get_node)
  return ok and node or nil
end

local M = {}

M.start = function()
  nodes = {}
  local node = pget_node()
  if not node then
    return vim.cmd('normal! viW')
  end

  if nv.treesitter.is_comment() then
    skip = true
    return vim.cmd('normal! viW')
  end

  skip = false
  insert_and_select(node)
end

M.increment = function()
  if skip then
    skip = false
    insert_and_select(pget_node())
    return
  end
  local cur = nodes[#nodes]
  insert_and_select(cur and cur:parent() or nil)
end

M.decrement = function()
  table.remove(nodes)
  local prev = nodes[#nodes]
  if prev then
    select_node(prev)
  end
end

return M
