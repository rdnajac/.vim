local function track(fn)
  local t1 = vim.uv.hrtime()
  local ok, res = pcall(fn)
  local t2 = vim.uv.hrtime()
  local dt = (t2 - t1) / 1e6
  vim.notify(string.format('Elapsed time: %.2f ms', dt), vim.log.levels.INFO, {
    title = 'nvim.util.track',
  })
  if not ok then
    error(res)
  end
  return res
end

return track
