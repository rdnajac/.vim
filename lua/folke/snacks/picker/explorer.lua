---@module "snacks"
---@type snacks.picker.explorer.Config
return {
  ignored = true,
  win = {
    list = {
      keys = {
        ['-'] = 'explorer_up',
        ['<Left>'] = 'explorer_up',
        ['<Right>'] = 'confirm',
      },
    },
  },
  -- https://github.com/folke/snacks.nvim/discussions/1306#discussioncomment-12248922
  on_show = function(picker)
    local show = false
    local gap = 1
    local clamp_width = function(value) return math.max(20, math.min(100, value)) end
    local rel = picker.layout.root
    local update = function(win) ---@param win snacks.win
      local border = win:border_size().left + win:border_size().right
      win.opts.row = vim.api.nvim_win_get_position(rel.win)[1]
      win.opts.height = 0.8
      win.opts.col = vim.api.nvim_win_get_width(rel.win) + gap
      win.opts.width = clamp_width(vim.o.columns - border - win.opts.col)
      win:update()
    end

    local preview_win = Snacks.win.new({
      relative = 'editor',
      external = false,
      focusable = false,
      border = 'rounded',
      backdrop = false,
      show = show,
      bo = {
        filetype = 'snacks_float_preview',
        buftype = 'nofile',
        buflisted = false,
        swapfile = false,
        undofile = false,
      },
      on_win = function(win)
        update(win)
        picker:show_preview()
      end,
    })

    rel:on('WinLeave', function()
      vim.schedule(function()
        if not picker:is_focused() then
          picker.preview.win:close()
        end
      end)
    end)

    rel:on('WinResized', function() update(preview_win) end)

    picker.preview.win = preview_win
    picker.main = preview_win.win
    picker.preview.win:toggle()
  end,
  -- actions = {
  --   toggle_preview = function(picker) --[[Override]]
  --     picker.preview.win:toggle()
  --   end,
  -- },
  -- on_close = function(picker)
  --   picker.preview.win:close()
  -- end,
}
