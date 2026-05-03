local api, fn, fs, M = vim.api, vim.fn, vim.fs, {}

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

---@param file string path appended to `stdpath('cache')`
---@param content any string, table, or function returning string/table
---@return string[] the contents as written, or nil on failure
M.write = function(file, content)
  fn.mkdir(fn.fnamemodify(file, ':h'), 'p')
  content = vim.is_callable(content) and content() or content
  if type(content) == 'table' and not vim.islist(content) then
    content = vim.json.encode(content, { indent = '\t', sort_keys = false })
  end
  content = type(content) == 'string' and vim.split(content, '\n') or content
  return fn.writefile(content, file) == 0 and content or nil
end

---@param filename string
---@return table
M.readjson = function(filename) return vim.json.decode(fn.readblob(filename)) end

local cache_dir = fn.stdpath('cache')

-- TODO: see `$PACKDIR/tokyonight.nvim/lua/tokyonight/util.lua`
--- Run fn() and cache result, or load from cache if file exists.
--- Tables are JSON-encoded; strings are split on newlines.
---@param path string cache file path (relative to stdpath.cache)
---@param fun fun(): string|table function that returns data to cache
---@return string|table
M.cache = function(path, fun)
  local fpath = fn.resolve(cache_dir .. '/' .. path)
  if fn.filereadable(fpath) == 1 then
    local ok, decoded = pcall(M.readjson, fpath)
    return ok and decoded or fn.readfile(fpath)
  end
  return M.write(fpath, fun())
end

function M.filesize()
  local size = fn.getfsize(fn.expand('%:p'))
  if size == -1 then
    error('file not found')
  elseif size == -2 then
    error('filesize too big to handle')
  end
  local prefixes = { '', 'K', 'M', 'G' }
  local i = 1
  while size > 1024 and i < #prefixes do
    size = size / 1024
    i = i + 1
  end

  local fmt = (i == 1 and '%d bytes' or '%.2f %sib')
  return string.format(fmt, size, prefixes[i])
end

M['goto'] = function()
  local line = vim.api.nvim_get_current_line()
  local lineno = line:match(':(%d+)') or 0
  local cfile = fn.expand('<cfile>')
  fn['edit#'](cfile)
  vim.cmd('normal! ' .. lineno .. 'G')
end

--- handles truncated paths in the debug.traceback like `.../path/to/file:line:`
---@param cfile? string defaults to `expand('<cfile>')`
M.better_gf = function(cfile)
  cfile = cfile or vim.fn.expand('<cfile>')
  if vim.startswith(cfile, '...') then
    -- HACK: the errors are probably from one of these two dirs
    local maybe = { PACKDIR = '/core/opt/', VIMRUNTIME = '/nvim/runtime/' }
    for dir, pattern in pairs(maybe) do
      local match = cfile:match('.*' .. pattern .. '(.*)')
      if match and match ~= '' then
        local file = vim.fs.joinpath(vim.env[dir], match)
        if file and vim.uv.fs_stat(file) then
          local line = vim.api.nvim_get_current_line()
          local line_num = line:match(cfile .. ':(%d+)')
          vim.cmd('close')
          vim.cmd.edit(file)
          if line_num then
            vim.cmd('normal! ' .. line_num .. 'G')
          end
          return
        end
      end
    end
  end
  vim.cmd('normal! gf')
end

return M
