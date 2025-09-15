vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    local startuptime = (vim.uv.hrtime() - _G.t0) / 1e6
    local logpath = vim.fs.joinpath(vim.fn.stdpath('data'), 'loader.log')
    local enabled_time = startuptime
    local enabled_cnt = 1
    local enabled_high = startuptime
    local enabled_low = startuptime

    -- read previous logs
    if vim.uv.fs_stat(logpath) then
      for line in io.lines(logpath) do
        local state, time = line:match('%w+: Loader (.+), ([^ ]+)ms')
        time = tonumber(time)
        if state == 'enabled' then
          enabled_cnt = enabled_cnt + 1
          enabled_time = enabled_time + time
          enabled_high = math.max(enabled_high, time)
          enabled_low = math.min(enabled_low, time)
        end
      end
    end

    local enabled_avg = enabled_time / enabled_cnt

    -- write new log entry
    local fd = assert(io.open(logpath, 'a+'))
    fd:write(
      ('%s: Loader enabled, %.2fms, avg: %.2fms\n'):format(os.date(), startuptime, enabled_avg)
    )
    fd:close()

    local stats = {
      avg = enabled_avg,
      high = enabled_high,
      low = enabled_low,
      cnt = enabled_cnt,
    }

    vim.g.loader_stats = stats

    -- notify
    if Snacks and Snacks.notify then
      Snacks.notify.info(
        ('Startup Loader: %.2fms\navg %.2fms,\nhigh %.2fms,\nlow %.2fms,\nruns %d)'):format(
          startuptime,
          stats.avg,
          stats.high,
          stats.low,
          stats.cnt
        )
      )
    end
  end,
})
