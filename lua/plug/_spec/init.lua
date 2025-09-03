-- let g:plug_home = join([stdpath('data'), 'site', 'pack', 'core', 'opt'], '/')
vim.g.plug_home = vim.fs.joinpath(vim.fn.stdpath('data'), 'site', 'pack', 'core', 'opt')

local M = {}


-- Autocmd setup for lazy configs
local aug = vim.api.nvim_create_augroup('LazyLoad', { clear = true })

---@param plugin PlugSpec
M.config = function(plugin)
  if vim.is_callable(plugin.config) then
    if plugin.event then
      vim.api.nvim_create_autocmd(plugin.event, {
        group = aug,
        once = true,
        callback = plugin.config,
      })
    else
      plugin.config()
    end
  end
end
