---@param buf number
---@param notif snacks.notifier.Notif
---@param ctx snacks.notifier.ctx
local function style(buf, notif, ctx)
  vim.api.nvim_buf_set_lines(buf, 0, 1, false, { '', '' })
  vim.api.nvim_buf_set_lines(buf, 2, -1, false, vim.split(notif.msg, '\n'))
  vim.api.nvim_buf_set_extmark(buf, ctx.ns, 0, 0, {
    virt_text = {
      { ' ' },
      { notif.icon, ctx.hl.icon },
      { ' ' },
      { notif.title or '', ctx.hl.title },
    },
    virt_text_win_col = 0,
    priority = 10,
  })
  vim.api.nvim_buf_set_extmark(buf, ctx.ns, 0, 0, {
    virt_text = {
      { ' ' },
      {
        string.format(
          '%s.%03d',
          os.date('%T', notif.added),
          math.floor((vim.uv.hrtime() / 1e6) % 1000)
        ),
        ctx.hl.title,
      },
      { ' ' },
    },
    virt_text_pos = 'right_align',
    priority = 10,
  })
  vim.api.nvim_buf_set_extmark(buf, ctx.ns, 1, 0, {
    virt_text = { { string.rep('━', vim.o.columns - 2), ctx.hl.border } },
    virt_text_win_col = 0,
    priority = 10,
  })
end

---@type snacks.notifier.Config
return {
  -- date_format: string = "%R",
  -- filter?: fun(notif: snacks.notifier.Notif):boolean,
  -- gap: integer = 0,
  -- height: table,
  -- icons: table,
  -- keep?: fun(notif: snacks.notifier.Notif):boolean,
  -- level: integer = 0,
  -- margin: table,
  -- more_format: boolean|string,
  -- padding: boolean = true,
  -- refresh: integer = 50,
  -- sort: table,
  style = style,
  -- timeout: integer = 3000,
  -- top_down: boolean = true,
  -- width: table,
}
