local M = {}

setmetatable(M, {
  __index = function(t, k)
    t[k] = require('nvim.util.' .. k)
    return t[k]
  end,
})

-- keep track of stuff
M.did = vim.defaulttable()

-- Cache standard paths to avoid multiple function calls
M.stdpath = {}
for path_type in string.gmatch('cache config data state', '%S+') do
  M.stdpath[path_type] = vim.fn.stdpath(path_type)
end

M.is_nonempty_string = function(x)
  return type(x) == 'string' and x ~= ''
end

M.is_nonempty_list = function(t)
  return vim.islist(t) and #t > 0
end

local aug = vim.api.nvim_create_augroup('LazyLoad', {})

--- Lazy-load a function on its event or on UIEnter by default.
--- @param callback fun(ev?: vim.api.autocmd.callback.args) Callback when the event fires.
--- @param event? string|string[] The Neovim event(s) to watch (default: UIEnter)
--- @param pattern? string|string[] Optional pattern for events like FileType
M.lazyload = function(callback, event, pattern)
  vim.api.nvim_create_autocmd(event or 'UIEnter', {
    callback = type(callback) == 'function' and callback or function()
      vim.cmd(callback)
    end,
    group = 'LazyLoad',
    nested = true,
    once = true,
    pattern = pattern or '*',
  })
end

--- Same as require but handles errors gracefully
--- @param module string
--- @param errexit? boolean
--- @return any?
M.xprequire = function(module, errexit)
  local success, result = xpcall(require, debug.traceback, module)
  if not success then
    if errexit ~= false then
      local error_msg = ('Error loading module %s:\n%s'):format(module, result)
      vim.schedule(function()
        if errexit == true then
          error(error_msg)
        else
          vim.notify(error_msg, vim.log.levels.ERROR)
        end
      end)
    end
    return nil
  end
  return result
end

--  local gh = function(s)
--   return s:match('^[%w._-]+/[%w._-]+$') and 'https://github.com/' .. s .. '.git' or s
-- end

--- Returns the file path of the first non-self caller.
--- @return string|nil
M.source = function()
  local self_path = debug.getinfo(1, 'S').source:sub(2)
  local self_dir = vim.fn.fnamemodify(self_path, ':h')

  local stack_level = 2
  while true do
    local caller_info = debug.getinfo(stack_level, 'S')
    if not caller_info then
      return nil
    end

    local caller_source = caller_info.source
    if caller_source:sub(1, 1) == '@' then
      local absolute_path = vim.fn.fnamemodify(caller_source:sub(2), ':p')
      if not vim.startswith(absolute_path, self_dir) then
        return absolute_path
      end
    end
    stack_level = stack_level + 1
  end
end

M.is_comment = require('nvim.plugins.treesitter').is_comment

return M
