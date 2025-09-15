vim.api.nvim_create_autocmd('FileType', {
  pattern = 'snacks_notif',
  callback = function(ev)
    -- info(ev)
    -- require('render-markdown').set(true)
    -- vim.cmd('set ft=markdown')
  end,
})

vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    info(nv.did_setup)
    -- Stats table with inline metatable
    local stats = setmetatable({ total = 0, cnt = 0, high = 0, low = math.huge }, {
      __index = function(t, k)
        if k == 'avg' then
          return t.cnt > 0 and t.total / t.cnt or 0
        else
          return rawget(t, k)
        end
      end,
      __call = function(t, time)
        t.cnt = t.cnt + 1
        t.total = t.total + time
        t.high = math.max(t.high, time)
        t.low = math.min(t.low, time)
      end,
    })

    local startuptime = (vim.uv.hrtime() - _G.t0) / 1e6
    local state = vim.loader.enabled and 'enabled' or 'disabled'
    local logpath = vim.fs.joinpath(vim.fn.stdpath('data'), 'startuptime.log')

    -- Read previous log and accumulate only current state
    if vim.uv.fs_stat(logpath) then
      for line in io.lines(logpath) do
        local ts, s, t, a = line:match('^(%d+),(%w+),([%d%.]+),([%d%.]+)$')
        if ts and s == state and t then
          stats(tonumber(t))
        end
      end
    end

    stats(startuptime)

    local f = io.open(logpath, 'a+')
    if f then
      f:write(('%d,%s,%.6f,%.6f\n'):format(os.time(), state, startuptime, stats.avg))
      f:close()
    end

    -- Store global stats
    vim.g.loader_stats = stats

    -- TODO: why won't this markdown render
    local notify_msg = table.concat({
      ('**vim.loader [%s]**'):format(state),
      '',
      '| Metric | Value    |',
      '|--------|----------|',
      ('| Start  | %.2fms |'):format(startuptime),
      ('| Avg    | %.2fms |'):format(stats.avg),
      ('| High   | %.2fms |'):format(stats.high),
      ('| Low    | %.2fms |'):format(stats.low),
      ('| Runs   | %d       |'):format(stats.cnt),
    }, '\n')

    -- tell Snacks to use markdown filetype/style
    Snacks.notify.info(notify_msg, {
      title = 'Startup Time',
      ft = 'markdown', -- ensure buffer is markdown
    })
  end,
})
