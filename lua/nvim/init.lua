local api, cmd, fn, fs = vim.api, vim.cmd, vim.fn, vim.fs
local group = api.nvim_create_augroup('nv.autocmds', {})

local M = {
opts = vim.defaulttable() -- store plugin options here
}

local core_util = require('vim._core.util')

--- returns a special submodule metatable that lazy-loads its own submodules
---
M.submodule = function(prefix)
  return setmetatable({}, {
    __index = function(t, k)
      local modname = prefix .. '.' .. k
      local ok, m = xpcall(require, debug.traceback, modname)
      if ok then
        t[k] = m
        return m
      end
      error(([[`require('%s')` failed: %s]]):format(modname, m))
    end,
  })
end

M.ui = M.submodule('nvim.ui')

--- wrapper around the nvim_create_autocmd wrapper
---
--- @param events vim.api.keyset.events|vim.api.keyset.events[]
--- @param pattern_or_cb string|string[]|fun(ev)
--- @param cb? fun(ev) optional when second param is callable
M.on = function(events, pattern_or_cb, cb)
  -- local pattern = type(pattern_or_cb) == 'function' and '*' or pattern_or_cb
  local pattern
  if type(pattern_or_cb) == 'function' then
    cb, pattern = pattern_or_cb, '*'
  else
    pattern = pattern_or_cb
  end
  ---@cast cb fun(vim.api.keyset.create_autocmd.callback_args):boolean?
  return core_util.nvim_on(events, group, { pattern = pattern }, cb)
end

--- Run a Vim command and return the output as a list of lines
---@param vimcommand string Vim command to execute
---@return string[] output
M.exec = function(vimcommand)
  local res = vim.api.nvim_exec2(vimcommand, { output = true })
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

M.inside_code_fences = function()
  local ok, node = pcall(vim.treesitter.get_node)
  return (ok and node) and node:type():match('code') ~= nil or false
end

M.is_nonempty_string = function(v) return type(v) == 'string' and v ~= '' end
M.is_nonempty_list = function(v) return vim.islist(v) and #v > 0 end
M.is_visual = function() return fn.mode():match('[vV\22]') ~= nil end
M.synname = function(row, col) return fn.synIDattr(fn.synID(row, col, 1), 'name') end

function M.gen(path, lines)
  lines = vim.list_extend({ '-- This file is generated. Do not edit.' }, lines)
  vim.fn.mkdir(vim.fs.dirname(path), 'p')
  vim.fn.writefile(lines, path)
  vim.notify('File created: ' .. path, vim.log.levels.INFO)
  return path
end

M.capitalize = function(s) return s:gsub('^%l', string.upper) end
M.camelCase = function(s)
  return s:gsub('_(%a)', function(c) return c:upper() end):gsub('^%l', string.upper)
end

return M
