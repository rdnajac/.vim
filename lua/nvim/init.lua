local M = {}
local me = debug.getinfo(1, 'S').source
local api, fn, uv = vim.api, vim.fn, vim.uv

--- Millisecond-precision timestamp, e.g. `14:03:22.123`
--- @return string
M.now = function(t)
  return string.format('%s.%03d', os.date('%T', t), math.floor((uv.hrtime() / 1e6) % 1000))
end

M.trace = function()
  local trace = {} ---@type string[]
  for level = 2, 20 do -- arbitrary max depth
    local info = debug.getinfo(level, 'Sln')
    if not info then
      break
    elseif
      info.what ~= 'C'
      -- don't record calls from functions defined in init.lua
      -- and info.source ~= '@' .. os.getenv('MYVIMRC')
      and info.source ~= me
      and info.name ~= 'dd'
      -- don't record profiler calls if its overriding `require()`
      and not (vim.env.PROF and info.source:find('snacks[/\\]profiler'))
    then
      local line = ('--- %d. `%s:%s`%s'):format(
        #trace,
        vim.fn.fnamemodify(info.source, ':s/^@//:~:.'),
        info.currentline,
        info.name and ' _in_ **' .. info.name .. '**' or ''
      )
      table.insert(trace, line)
    end
  end
  return table.concat(trace, '\n')
end

local notify = function()
  return Snacks and Snacks.notify.warn or vim.print
end

M.dd = function(...)
  local t = M.now()
  local len = select('#', ...) ---@type number
  local obj = { ... } ---@type unknown[]
  local trace = M.trace()
  local content = len == 1 and obj[1] or len > 0 and obj or ''
  -- local function p() notify(trace .. content) end
  local function p()
    vim.print(t, trace, content)
  end
  return vim.in_fast_event() and vim.schedule_wrap(fn) or fn
end

local core_util = require('vim._core.util')
local aug = api.nvim_create_augroup('nv.aug', {})

--- https://github.com/neovim/neovim/discussions/40320
--- @param events vim.api.keyset.events|vim.api.keyset.events[]
--- @param opts vim.api.keyset.create_autocmd
--- @param cb string|fun(ev: vim.api.keyset.create_autocmd.callback_args): boolean?
--- @return integer
M.on = function(events, opts, cb)
  vim.validate('opts', opts, 'table')
  vim.validate('cb', cb, { 'function', 'string' })
  if type(cb) == 'function' then
    opts.callback = cb
  else
    opts.command = cb
  end
  opts.group = opts.group or aug
  return vim.api.nvim_create_autocmd(events, opts)
  -- return core_util.nvim_on(events, aug, opts, cb)
end

-- FIXME:
--- Prints the event param passed to the callback
---@param events vim.api.keyset.events|vim.api.keyset.events[]
---@param pattern? string|string[]
---@param cb? fun(ev:vim.api.keyset.create_autocmd.callback_args)
M.audebug = function(events, pattern, cb)
  return M.on(events, { pattern = pattern }, vim.is_callable(cb) and cb or M.dd)
end

--- see `:h open-file` for why this is correct
--- @param path string
M.open = function(path)
  local buf = fn.bufadd(vim.fs.normalize(path, { _fast = true }))
  -- fn.bufload(buf) -- triggers `BufReadPre`, `BufReadPost`, `FileType`
  -- vim.bo[buf].buflisted = true
  vim.api.nvim_buf_call(buf, vim.cmd.edit)
  -- vim.api.nvim_win_set_buf(0, buf)
  -- return core_util.edit_in(0, vim.fs.normalize(path, { _fast = true }))
end


-- TODO: yank and print function

--- Run a Vim command and return the output as a list of lines
--- @param vimcommand string Vim command to execute
--- @return string[] output
M.exec = function(vimcommand)
  local ret = api.nvim_exec2(vimcommand, { output = true }).output
  fn.setreg('+', ret)
  return vim.split(ret, '\n', { trimempty = true })
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
  local type = (ok and node and node:type()) or fn.synIDattr(fn.synID(cursor[1], cursor[2] + 1, 1), 'name')
  return not not type:match('comment')
end

--- handles truncated paths in the debug.traceback like `.../path/to/file:line:`
--- @param cfile? string defaults to `expand('<cfile>')`
--- @return string? Vim command to execute
M.goto_file = function(cfile)
  cfile = cfile or fn.expand('<cfile>')
  if vim.startswith(cfile, '...') then
    -- HACK: the errors are probably from one of these two dirs
    for dir, pattern in pairs({ PACKDIR = '/core/opt/', VIMRUNTIME = '/nvim/runtime/' }) do
      local match = cfile:match('.*' .. pattern .. '(.*)')
      if match and match ~= '' then
        local file = vim.fs.joinpath(vim.env[dir], match)
        if vim.uv.fs_stat(file) then
          vim.cmd.wincmd('w')
          M.open(file)
          return ''
        end
      end
    end
  end
  return '<C-w><C-f>'
end

--- Get all lines from a buffer as a list of strings
---
--- @param bufnr integer? buffer number, defaults to current buffer
--- @return string[] lines
M.get_buf_lines = function(bufnr)
  bufnr = bufnr or api.nvim_get_current_buf() -- vim._resolve_bufnr
  local nlines = api.nvim_buf_line_count(bufnr)
  return api.nvim_buf_get_lines(bufnr, 0, nlines, false)
end

M.json = {}
M.json.formatexpr = function()
  local indent = vim.bo.expandtab and (' '):rep(vim.o.shiftwidth) or '\t'
  local lines = api.nvim_buf_get_lines(0, vim.v.lnum - 1, vim.v.lnum + vim.v.count - 1, true)
  local o = vim.json.decode(table.concat(lines, '\n'))
  local stringified = vim.json.encode(o, { indent = indent, sort_keys = true })
  lines = vim.split(stringified, '\n')
  api.nvim_buf_set_lines(0, vim.v.lnum - 1, vim.v.count, true, lines)
end
function M.json.read(path)
  local ok, ret = pcall(function()
    return vim.json.decode(vim.fn.readblob(path), { luanil = {
      object = true,
      array = true,
    } })
  end)
  return ok and ret or nil
end
-- function M.json.write(data, fname) vim.fn.writefile(vim.json.encode(data), vim.fs.joindir(cache, fname)) end

local cache = vim.fn.stdpath('cache')
function M.cache(data, fname)
  fn.writefile(vim.json.encode(data), vim.fs.joinpath(cache, fname))
end

M.str = {}
M.str.capitalize = function(s)
  return s:gsub('^%l', string.upper)
end
M.str.camelCase = function(s)
  -- stylua: ignore
  return s:gsub('_(%a)', function(c) return c:upper() end):gsub('^%l', string.upper)
end

function M.gen_file(path, lines)
  vim.fn.writefile(
    vim.list_extend({
      '-- This file is generated. Do not edit.',
    }, lines),
    path
  )
  vim.notify('File created: ' .. path, vim.log.levels.INFO)
  return path
end


local function submodule(_M, prefix)
  _M = _M or {}
  setmetatable(_M, {
    __index = function(t, k)
      local modname = prefix .. '.' .. k
      local ok, m = xpcall(require, debug.traceback, modname)
      if ok then
        if type(m) == 'table' then
          -- wrap the newly loaded module so its keys also lazy-loaded
          submodule(m, modname)
        end
        t[k] = m
        return m
      end
      -- new proxy anyway so deeper nesting works without an intermediate `init.lua`
      local proxy = {}
      submodule(proxy, modname)
      t[k] = proxy
      return proxy
    end,
  })
  return _M
end

submodule(M, 'nvim')
return M
