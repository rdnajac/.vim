_G.selected_nodes = {}

local M = {}

local function select_node(node)
  if node then
    local start_row, start_col, end_row, end_col = node:range()
    vim.fn.setpos("'<", { 0, start_row + 1, start_col + 1, 0 })
    vim.fn.setpos("'>", { 0, end_row + 1, end_col, 0 })
    vim.cmd('normal! gv')
  end
end

M.start = function()
  _G.selected_nodes = {}
  local current_node = vim.treesitter.get_node()
  if current_node then
    table.insert(_G.selected_nodes, current_node)
    select_node(current_node)
  end
end

M.increment = function()
  local current_node = _G.selected_nodes[#_G.selected_nodes]
  if current_node then
    local parent = current_node:parent()
    if parent then
      table.insert(_G.selected_nodes, parent)
      select_node(parent)
    end
  end
end

M.decrement = function()
  table.remove(_G.selected_nodes)
  local current_node = _G.selected_nodes[#_G.selected_nodes]
  if current_node then
    select_node(current_node)
  end
end

return M
