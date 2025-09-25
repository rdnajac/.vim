-- TODO: work this into custom vim.notify
_G.lap = function(msg)
  local now = vim.uv.hrtime()
  local prev = t[#t]
  table.insert(t, now)

  local lap_num = #t - 1
  local total_ms = (now - t[1]) / 1e6
  local lap_ms = (now - prev) / 1e6

  print(('%2d: %-24s %8.3f (%7.3f)'):format(lap_num, msg or '', lap_ms, total_ms))
end
