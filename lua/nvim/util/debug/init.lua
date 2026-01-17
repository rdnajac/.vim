local M = {}

local MAX_INSPECT_LINES = 2 ^ 10

local notify = _G.dd or vim.print
-- local notify = function(...) Snacks and Snacks.notify.warn(...) or vim.print(...) end

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

local function get_caller(skip_levels, predicate)
  for level = skip_levels or 2, 10 do
    local info = debug.getinfo(level, 'S')
    if info and info.what ~= 'C' and info.source ~= 'lua' then
      if not predicate or predicate(info) then
        return info
      end
    end
  end
end

local function format_source(source) return vim.fn.fnamemodify(source:sub(2), ':p:~:.') end

local function should_include_in_trace(info)
  return info
    and info.what ~= 'C'
    and info.source ~= 'lua'
    and not info.source:find('snacks[/\\]debug')
end

M.dd = function(...)
  local len = select('#', ...) ---@type number
  local obj = { ... } ---@type unknown[]
  local me = debug.getinfo(1, 'S')
  local caller = get_caller(
    2,
    function(info)
      return info.source ~= me.source and info.source ~= '@' .. (os.getenv('MYVIMRC') or '')
    end
  )
  vim.schedule(function()
    local lines = vim.split(vim.inspect(len == 1 and obj[1] or len > 0 and obj or nil), '\n')
    notify(lines, {
      title = 'Debug: ' .. format_source(caller.source) .. ':' .. caller.linedefined,
      ft = 'lua',
    })
  end)
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

return M
