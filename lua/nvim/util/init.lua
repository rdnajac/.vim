local api, fn, fs = vim.api, vim.fn, vim.fs

-- TODO: implement one-time install func to hook into packinstall event
-- once = function() vim.cmd.MasonInstall(nv.util.tools()) end,
local M = {
  tools = function()
    local tools = {
      'actionlint', -- code action linter
      'mmdc', -- mermaid diagrams
      'tree-sitter-cli',
    }

    -- TODO: find other tools in lsp dir
    local function other_tools()
      local ret = {}
      ret[#ret + 1] = 'stylua'
      return ret
    end

    return vim.list_extend(tools, other_tools())
  end,
}

M.capitalize = function(s) return s:sub(1, 1):upper() .. s:sub(2):lower() end
M.camelCase = function(s)
  return s:gsub('_(%a)', function(c) return c:upper() end):gsub('^%l', string.upper)
end

--- Run a Vim command and return the output as a list of lines
---@param cmd string Vim command to execute
---@return string[] output
M.exec = function(cmd)
  local res = vim.api.nvim_exec2(cmd, { output = true })
  return vim.split(res.output, '\n', { trimempty = true })
end

--- Get all lines from a buffer as a list of strings
---@param bufnr integer? buffer number, defaults to current buffer
---@return string[] lines
M.get_buf_lines = function(bufnr)
  bufnr = bufnr or api.nvim_get_current_buf()
  local nlines = api.nvim_buf_line_count(bufnr)
  return api.nvim_buf_get_lines(bufnr, 0, nlines, false)
end

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

M.is_nonempty_string = function(v) return type(v) == 'string' and v ~= '' end
M.is_nonempty_list = function(v) return vim.islist(v) and #v > 0 end
M.is_visual = function() return fn.mode():match('[vV\22]') ~= nil end
M.synname = function(row, col) return fn.synIDattr(fn.synID(row, col, 1), 'name') end
M.inside_code_fences = function()
  local ok, node = pcall(vim.treesitter.get_node)
  return (ok and node) and node:type():match('code') ~= nil or false
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

--- run a system command and return stdout using `vim.system`
---@param cmd string[] command and args
---@param err_exit? boolean whether to error if command fails
---@param errmsg string? error message to use if err_exit is true
---@param stdin string? optional stdin to pass to command
---@return string? stdout on success
function M.run(cmd, err_exit, errmsg, stdin)
  local rv = vim.system(cmd, { stdin = stdin, text = true }):wait()
  if rv.code ~= 0 then
    if rv.stdout and #rv.stdout > 0 then
      print(rv.stdout)
    end
    if rv.stderr and #rv.stderr > 0 then
      print(rv.stderr)
    end
    local msg = errmsg or ('Command failed: %s'):format(table.concat(cmd, ' '))
    if err_exit then
      error(msg)
    else
      vim.notify(msg, vim.log.levels.ERROR)
    end
    return nil
  end
  return rv.stdout
end

-- TODO:
-- local ns = vim.api.nvim_create_namespace('hl_on_paste')
-- vim.paste = (function(overridden)
--   return function(lines, phase)
--     local ret = overridden(lines, phase)
--     vim.hl.range(0, ns, 'Visual', "'[", "']", { timeout = 300 })
--     return ret
--   end
-- end)(vim.paste)

-- local _, mod = xpcall(require, debug.traceback, 'nvim.' .. modname)

return M
