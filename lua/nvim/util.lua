local M = {}

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
    callback = cb,
    group = 'LazyLoad',
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

return M
