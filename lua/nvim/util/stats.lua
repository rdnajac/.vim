vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    local Stat = {}
    Stat.__index = function(t, k)
      if k == "avg" then
        return t.cnt > 0 and t.total / t.cnt or 0
      else
        return rawget(t, k)
      end
    end
    Stat.__call = function(t, time)
      t.cnt = t.cnt + 1
      t.total = t.total + time
      t.high = math.max(t.high, time)
      t.low = math.min(t.low, time)
    end
    local function new_stat() return setmetatable({ total = 0, cnt = 0, high = 0, low = math.huge }, Stat) end

    local stats = { enabled = new_stat(), disabled = new_stat() }
    local startuptime = (vim.uv.hrtime() - _G.t0) / 1e6
    local logpath = vim.fs.joinpath(vim.env.HOME, '.nvim_startuptime.log')
    local state = enable_loader and "enabled" or "disabled"

    -- Read log and accumulate
    if vim.uv.fs_stat(logpath) then
      for line in io.lines(logpath) do
        local s, time = line:match("Loader (enabled|disabled), ([^ ]+)ms")
        if s and time then
          stats[s](tonumber(time))
        end
      end
    end

    -- Update current startup
    stats[state](startuptime)

    -- Append to log
    assert(io.open(logpath, 'a+')):write(
      ("%s: Loader %s, %sms, avg: %sms\n"):format(os.date(), state, startuptime, stats[state].avg)
    ):close()

    -- Global stats
    vim.g.loader_stats = stats

    -- Notify
    if Snacks and Snacks.notify then
      local s = stats[state]
      Snacks.notify.info(
        ('Startup Loader: %.2fms\navg %.2fms,\nhigh %.2fms,\nlow %.2fms,\nruns %d'):format(
          startuptime,
          s.avg,
          s.high,
          s.low,
          s.cnt
        )
      )
    end
  end,
})
