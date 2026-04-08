--- https://github.com/folke/snacks.nvim/discussions/1306#discussioncomment-12248922
---@type snacks.picker.explorer.Config
return {
  on_show = function(picker)
    picker.layout.wins.preview.layout = false
    local root = picker.layout.root
    local preview = picker.preview.win
    preview.opts.relative = 'editor'

    local update = function()
      local border = preview:border_size()
      preview.opts.row = vim.api.nvim_win_get_position(root.win)[1]
      preview.opts.col = vim.api.nvim_win_get_width(root.win)
      preview.opts.height = 0.8
      preview.opts.width =
        math.max(20, math.min(100, vim.o.columns - border.left - border.right - preview.opts.col))
      if preview:valid() then
        preview:update()
      end
    end

    local orig_on_win = preview.opts.on_win --[[@as function]]
    preview.opts.on_win = function(win)
      orig_on_win(win)
      update()
    end

    root:on('WinResized', update)
    root:on('WinLeave', function()
      vim.schedule(function()
        if not picker:is_focused() then
          picker:toggle('preview', { enable = false })
        end
      end)
    end)

    -- auto-show preview when opening nvim on a directory
    if vim.fn.argc() == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
      picker:toggle('preview', { enable = true })
    end
  end,

}
