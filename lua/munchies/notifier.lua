--- adds milliseconds to the timestamp and adds a border below the title
---@type snacks.notifier.render
local style = function(buf, n, ctx)
  -- set up a buffer starting with two empty lines followed by the message
  local lines = vim.list_extend({ '', '' }, vim.split(n.msg, '\n'))
  local title = (n.title or ''):gsub('Debug: lua:0', vim.fn.histget('cmd', -1))
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_extmark(buf, ctx.ns, 0, 0, {
    virt_text = { { n.icon, ctx.hl.icon }, { ' ' }, { title, ctx.hl.title } },
    virt_text_win_col = 1,
    priority = 10,
  })
  vim.api.nvim_buf_set_extmark(buf, ctx.ns, 0, 0, {
    virt_text = {
      {
        ('[%s.%03d] '):format(os.date('%T', n.added), math.floor((vim.uv.hrtime() / 1e6) % 1000)),
        ctx.hl.title,
      },
    },
    virt_text_pos = 'right_align',
    priority = 10,
  })
  -- add a border below the title
  vim.api.nvim_buf_set_extmark(buf, ctx.ns, 1, 0, {
    virt_text = { { string.rep('━', vim.wo.columns - 2), ctx.hl.border } },
    virt_text_win_col = 0,
    priority = 10,
  })
end
