local M = {}

local modname = function(path)
  local name = vim.fn.fnamemodify(path, ':r:s?^.*/lua/??'):gsub('/', '.')
  return name:sub(-4) == 'init' and name:sub(1, -6) or name
end

local formats = {
  module = function(module) return module end,
  require = function(module) return ([[require('%s')]]):format(module) end,
  require_func = function(module)
    -- TODO: make this gopd
    if vim.trim(vim.fn.expand('<cword>')) == '' then
      return ([[require('%s')]]):format(module)
    end
    return ([[require('%s').%s()]]):format(module, vim.fn.expand('<cword>'))
  end,
}

local function yankmod(format)
  local text = formats[format](modname(vim.fn.expand('%:p')))
  Snacks.notify.info('yanked: ' .. text)
  vim.fn.setreg('*', text)
end

-- stylua: ignore start
M.require      = function() yankmod('require')      end
M.require_func = function() yankmod('require_func') end

M.test = function() yankmod('test') end

return M
