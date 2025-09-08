-- Run plugin config (lazy if event is set)
function Plugin:lazyload()
  if not vim.is_callable(self.spec.config) then
    return
  end
  if self.spec.event then
    local aug = vim.api.nvim_create_augroup('LazyLoad', { clear = true })
    vim.api.nvim_create_autocmd(self.spec.event, {
      group = aug,
      once = true,
      callback = self.spec.config,
    })
  else
    self.spec.config()
  end
end

-- Autocmd setup for lazy configs
local aug = vim.api.nvim_create_augroup('LazyLoad', { clear = true })

-- TODO: handle ft events
function M:do_config()
  if vim.is_callable(self.config) then
    if self.event then
      vim.api.nvim_create_autocmd(self.event, {
        group = aug,
        once = true,
        callback = self.config,
      })
    else
      self.config()
    end
  end
end
