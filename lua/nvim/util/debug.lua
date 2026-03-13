local M = {}

local me = debug.getinfo(1, 'S').source

local now = function()
  return string.format('%s.%03d', os.date('%T'), math.floor((vim.uv.hrtime() / 1e6) % 1000))
end

M.print = function()
  local ft = vim.bo.filetype
  -- if ft == 'r' and package.loaded['r'] then return debug_r() end
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local word = vim.fn.expand('<cWORD>'):gsub(',$', '') -- trim trailing comma
  local templates = {
    lua = 'print(' .. word .. ')',
    c = string.format('printf("+++ %d %s: %%d\\n", %s);', row, word, word),
    sh = string.format('echo "+++ %d %s: $%s"', row, word, word),
    r = word,
    vim = ([[echom %s]]):format(word),
  }
  if vim.tbl_contains(vim.tbl_keys(templates), ft) then
    vim.api.nvim_buf_set_lines(0, row, row, true, { templates[ft] })
  end
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

-- local notify = vim.print
local notify = Snacks and Snacks.notify.warn or vim.print
-- local notify = function() return Snacks and Snacks.notify.warn or vim.print end

M.dd = function(...)
  local t = now()
  local len = select('#', ...) ---@type number
  local obj = { ... } ---@type unknown[]
  local trace = require('nvim.util.debug').trace()
  local content = len == 1 and obj[1] or len > 0 and obj or ''
  -- local function p() notify(trace .. content) end
  local function p() vim.print(t, trace, content) end
  return vim.in_fast_event() and vim.schedule(p) or p()
end

-- Very simple function to profile a lua function.
-- * **flush**: set to `true` to use `jit.flush` in every iteration.
-- * **count**: defaults to 100
---@param fn fun()
---@param opts? {count?: number, flush?: boolean}
M.profile = function(fn, opts)
  opts = vim.tbl_extend('force', { count = 100, flush = true }, opts or {})
  local uv = vim.uv
  local start = uv.hrtime()
  for _ = 1, opts.count, 1 do
    if opts.flush then
      jit.flush(fn, true)
    end
    fn()
  end
  notify(((uv.hrtime() - start) / 1e6 / opts.count) .. 'ms', { title = 'Profile' })
end

local aug = vim.api.nvim_create_augroup('audebug', {})

--- @param event vim.api.keyset.events|vim.api.keyset.events[]
--- @param pattern? string|string[]
--- @param cb? fun(ev:vim.api.keyset.create_autocmd.callback_args)
M.audebug = function(event, pattern, cb)
  return vim.api.nvim_create_autocmd(event, {
    group = aug,
    pattern = type(pattern) == 'string' and pattern or '*',
    callback = vim.is_callable(cb) and cb or _G.dd,
  })
end

-- count keys used in all subtables
M.key_counts = function(t)
  local ret = {}
  for _, v in pairs(t) do
    if type(v) == 'table' then
      for key in pairs(v) do
        ret[key] = (ret[key] or 0) + 1
      end
    end
  end
  return ret
end

M.upvalue = function(func, name, newvalue)
  local i = 1
  while true do
    local n = debug.getupvalue(func, i)
    if not n then
      break
    end
    if n == name then
      vim.notify('upvalue found: ' .. name .. ' = ' .. tostring(debug.getupvalue(func, i)))
      if newvalue then
        debug.setupvalue(func, i, newvalue)
        vim.notify('upvalue set: ' .. name)
      end
      return
    end
    i = i + 1
  end
  error('upvalue not found: ' .. name)
end

---Same as require but handles errors gracefully
---@param module string
---@param errexit? boolean
---@return any?
M.xprequire = function(module, errexit)
  local ok, mod = xpcall(require, debug.traceback, module)
  if not ok then
    if errexit ~= false then
      local msg = ('Error loading module %s:\n%s'):format(module, mod)
      vim.schedule(function()
        if errexit == true then
          error(msg)
        else
          vim.notify(msg, vim.log.levels.ERROR)
        end
      end)
    end
    return nil
  end
  return mod
end

return M
