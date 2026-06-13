local api, fn, fs = vim.api, vim.fn, vim.fs
local aug = vim.api.nvim_create_augroup('nv.autocmds', {})

local M = {
  --- @param events vim.api.keyset.events|vim.api.keyset.events[] Event(s) to watch. See |autocmd-events|.
  --- @param pattern_or_cb string|string[]|fun()
  --- @param cb fun()
  on = function(events, pattern_or_cb, cb)
    local pattern
    if type(pattern_or_cb) == 'function' then
      cb, pattern = pattern_or_cb, '*'
    else
      pattern = pattern_or_cb
    end
    return require('vim._core.util').nvim_on(events, aug, { pattern = pattern }, cb)
  end,
}

M.bigfile = function()
  vim.b.completion = false
  vim.b.minihipatterns_disable = true
  if vim.fn.exists(':NoMatchParen') == 2 then
    vim.cmd.NoMatchParen()
  end
  vim.cmd([[setlocal foldmethod& statuscolumn& conceallevel&]])
  vim.schedule(function()
    vim.notify(
      ('This is a beeeg file (%s)!'):format(
        Snacks.debug.size(fn.getfsize(fn.expand('%:p'))),
        vim.log.levels.WARN
      )
    )
    if api.nvim_buf_is_valid(0) then
      local ft = vim.filetype.match({ buf = 0 }) -- or ''
      -- for json files, keep the filetype as json
      -- for other files, set the syntax to the detected ft
      vim.bo[ft == 'json' and 'filetype' or 'syntax'] = ft
    end
  end)
end

M.on('FileType','bigfile', M.bigfile)

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

M.inside_code_fences = function()
  local ok, node = pcall(vim.treesitter.get_node)
  return (ok and node) and node:type():match('code') ~= nil or false
end

M.is_nonempty_string = function(v) return type(v) == 'string' and v ~= '' end
M.is_nonempty_list = function(v) return vim.islist(v) and #v > 0 end
M.is_visual = function() return fn.mode():match('[vV\22]') ~= nil end
M.synname = function(row, col) return fn.synIDattr(fn.synID(row, col, 1), 'name') end

--- handles truncated paths in the debug.traceback like `.../path/to/file:line:`
---@param cfile? string defaults to `expand('<cfile>')`
M.better_gf = function(cfile)
  cfile = cfile or vim.fn.expand('<cfile>')
  if vim.startswith(cfile, '...') then
    -- HACK: the errors are probably from one of these two dirs
    for dir, pattern in pairs({
      PACKDIR = '/core/opt/',
      VIMRUNTIME = '/nvim/runtime/',
    }) do
      local match = cfile:match('.*' .. pattern .. '(.*)')
      if match and match ~= '' then
        local file = vim.fs.joinpath(vim.env[dir], match)
        if file and vim.uv.fs_stat(file) then
          vim.cmd('close')
          fn['edit#goto'](file)
          return
        end
      end
    end
  end
  vim.cmd('normal! gf')
end

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
