local M = setmetatable({}, {
  __call = function(M, ...)
    return M.bench(...)
  end,
})

function M.bench(fn, opts)
  opts = opts or {}
  if not opts.title then
    local info = debug.getinfo(fn, 'n')
    opts.title = info.name or tostring(fn)
  end
  print('Benchmarking: ' .. opts.title .. '(x' .. (opts.count or 100) .. ')')
  Snacks.debug.profile(fn, opts)
end

return M
