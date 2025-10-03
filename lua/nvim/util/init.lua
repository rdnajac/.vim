local M = {}

setmetatable({}, {
  __index = function(t, k)
    t[k] = require('nvim.util.' .. k)
    -- return rawget(t, k)
    return t[k]
  end,
})

-- keep track of stuff
M.did = vim.defaulttable()

-- cache these to avoid multiple function calls
M.stdpath = {}
for d in string.gmatch('cache config data state', '%S+') do
  M.stdpath[d] = vim.fn.stdpath(d)
end

M.is_nonempty_string = function(x)
  return type(x) == 'string' and x ~= ''
end

M.is_nonempty_list = function(t)
  return vim.islist(t) and #t > 0
end

local aug = vim.api.nvim_create_augroup('LazyLoad', {})
--- Lazy-load a function on its event or on UIEnter by default.
-- TODO:  fix this signature
---@param cb fun(ev?: vim.api.autocmd.callback.args)  Callback when the event fires.
---@param event? string|string[] The Neovim event(s) to watch (default: VimEnter)
---@param pattern? string|string[] Optional pattern for events like FileType
M.lazyload = function(cb, event, pattern)
  vim.api.nvim_create_autocmd(event or 'UIEnter', {
    callback = type(cb) == 'function' and cb or function()
      vim.cmd(cb)
    end,
    group = 'LazyLoad',
    nested = true,
    once = true,
    pattern = pattern and pattern or '*',
  })
end

--- Same as require but handles errors gracefully
---
--- @param module string
--- @param errexit? boolean
--- @return any?
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

--  local gh = function(s)
--   return s:match('^[%w._-]+/[%w._-]+$') and 'https://github.com/' .. s .. '.git' or s
-- end

--- Returns the file path of the first non-self caller.
---@return string|nil
M.source = function()
  local self_path = debug.getinfo(1, 'S').source:sub(2)
  local self_dir = vim.fn.fnamemodify(self_path, ':h')

  local i = 2
  while true do
    local info = debug.getinfo(i, 'S')
    if not info then
      return nil
    end

    local src = info.source
    if src:sub(1, 1) == '@' then
      local abs = vim.fn.fnamemodify(src:sub(2), ':p')
      if not vim.startswith(abs, self_dir) then
        return abs
      end
    end
    i = i + 1
  end
end

M.is_comment = require('nvim.plugins.treesitter').is_comment

return M
