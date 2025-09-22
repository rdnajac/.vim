local aug = vim.api.nvim_create_augroup('LazyLoad', {})
--- Lazy-load a function on its event or on VimEnter by default.
---@param cb fun() The function to call when the event fires
---@param event? string|string[] The Neovim event(s) to watch (default: VimEnter)
---@param pattern? string|string[] Optional pattern for events like FileType
local function lazyload(cb, event, pattern)
  vim.api.nvim_create_autocmd(event or 'VimEnter', {
    callback = function(ev)
      cb()
    end,
    group = aug,
    once = true,
    pattern = pattern and pattern or '*',
  })
end

return setmetatable({}, {
  __call = function(_, ...)
    return lazyload(...)
  end,
})
