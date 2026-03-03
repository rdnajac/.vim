local aug = vim.api.nvim_create_augroup('2lazy4lazy', {})

--- execute a callback once at an event
---@param event string|string[]
---@param cb fun() the module's setup function with opts
local on_event = function(event, cb)
  vim.api.nvim_create_autocmd(event, {
    callback = cb,
    group = aug,
    -- nested = true,
    once = true,
  })
end

--- If `event` is specified, defers setup until the event fires.
--- Ensures setup runs only once via `did_init` flag.
function M.init(self)
  self.did_init = false

  local function _init()
    if self.did_init then
      return
    end
    local opts = vim.is_callable(self.opts) and self.opts() or self.opts
    if type(opts) == 'table' then
      require(self:modname()).setup(opts)
    elseif vim.is_callable(self.config) then
      self.config()
    end
    vim.schedule(function() self:register_keys() end)
    self.did_init = true
  end

  if self.event then
    on_event(self.event, _init)
  else
    _init()
  end
end

return M
