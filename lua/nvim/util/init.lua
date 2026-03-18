local api, fn, fs = vim.api, vim.fn, vim.fs

local tools = {
  'actionlint', -- code action linter
  'mmdc', -- mermaid diagrams
  'tree-sitter-cli',
}

local function other_tools()
  local ret = {}
  -- TODO: find other tools in lsp dir
  ret[#ret + 1] = 'stylua'
  return ret
end

local M = {}

M.tools = function() return vim.list_extend(tools, other_tools()) end

-- string manipulation
M.capitalize = function(s) return s:sub(1, 1):upper() .. s:sub(2):lower() end
M.camelCase = function(s)
  return s:gsub('_(%a)', function(c) return c:upper() end):gsub('^%l', string.upper)
end

-- shared
M.is_nonempty_string = function(v) return type(v) == 'string' and v ~= '' end
M.is_nonempty_list = function(v) return vim.islist(v) and #v > 0 end
-- TODO: is_visual_mode

-- api wrappers
M.get_buf_lines = function(bufnr)
  bufnr = bufnr or api.nvim_get_current_buf()
  local nlines = api.nvim_buf_line_count(bufnr)
  return api.nvim_buf_get_lines(bufnr, 0, nlines, false)
end

M.synname = function(row, col) return fn.synIDattr(fn.synID(row, col, 1), 'name') end

---@param opts? vim.treesitter.get_node.Opts
M.is_comment = function(opts)
  opts = opts or {}
  opts.bufnr = opts.bufnr or api.nvim_get_current_buf()
  local cursor = api.nvim_win_get_cursor(0)
  -- subtract one to account for 0-based row indexing in get_node
  opts.pos = opts.pos or { cursor[1] - 1, cursor[2] }

  local ok, node = pcall(vim.treesitter.get_node, opts)
  -- opts.pos is 0-indexed; synID expects 1-based row and col
  local type = (ok and node and node:type()) or M.synname(cursor[1], cursor[2] + 1)
  return not not type:match('comment')
end

M.exec = function(cmd)
  local res = vim.api.nvim_exec2(cmd, { output = true })
  return vim.split(res.output, '\n', { trimempty = true })
end

-- local ns = vim.api.nvim_create_namespace('hl_on_paste')
-- vim.paste = (function(overridden)
--   return function(lines, phase)
--     local ret = overridden(lines, phase)
--     vim.hl.range(0, ns, 'Visual', "'[", "']", { timeout = 300 })
--     return ret
--   end
-- end)(vim.paste)

M.yank = function(text)
  fn.setreg('*', text)
  print('[yanked] ' .. text)
end

--- Convert a file path to a module name by trimming the lua root
---@param path string
---@return string
M.modname = function(path)
  -- return fn.fnamemodify(path, ':r:s?^.*/lua/??'):gsub('/init$', '')
  local modname = (vim.endswith(path, '/init.lua') and path:sub(1, -10) or path):gsub('^.*/lua/', '')
  return modname
end

M.yankmod = function()
  local modname = M.name(api.nvim_buf_get_name(0))
  local line = string.format([[require('%s')]], modname)
  M.yank(line)
end

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
