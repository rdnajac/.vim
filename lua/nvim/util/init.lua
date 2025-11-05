local M = {}

local prefixes = {
  'nvim.util',
  'nvim',
  'nvim.config',
  'nvim.plugins',
}

local stats = {
  hits = 0,
  misses = 0,
}

function M.stats() return stats end

return setmetatable(M, {
  __index = function(t, k)
    for _, prefix in ipairs(prefixes) do
      local ok, mod = pcall(require, prefix .. '.' .. k)
      if ok then
	stats.hits = stats.hits + 1
        t[k] = mod
        return mod
      end
    end
      stats.misses = stats.misses + 1
  return nil
  end,
})
