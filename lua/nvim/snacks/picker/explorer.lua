---@module "snacks"
---@type snacks.picker.explorer.Config
return {
  -- cwd = vim.fn.getcwd(),
  ignored = true,
  win = {
    -- wo = { winhighlight = 'WinBar:NONE' },
    list = {
      keys = {
        -- ['<Up>'] = 'explorer_up',
        -- ['<Down>'] = 'explorer_down',
        ['<Left>'] = 'explorer_up',
        ['<Right>'] = 'confirm',
        ['<BS>'] = 'explorer_up',
        ['-'] = 'explorer_up',
        ['l'] = 'confirm',
        ['h'] = 'explorer_close', -- close directory
        ['a'] = 'explorer_add',
        ['d'] = 'explorer_del',
        ['c'] = 'explorer_copy',
        ['m'] = 'explorer_move',
        ['o'] = 'explorer_open', -- open with system application
        ['p'] = 'explorer_paste',
        ['r'] = 'explorer_rename',
        ['u'] = 'explorer_update',
        ['y'] = { 'explorer_yank', mode = { 'n', 'x' } },
        ['P'] = 'toggle_preview',
        ['<c-c>'] = 'tcd',
        ['<leader>/'] = 'picker_grep',
        ['<c-t>'] = 'terminal',
        ['.'] = 'explorer_focus',
        ['I'] = 'toggle_ignored',
        ['H'] = 'toggle_hidden',
        ['Z'] = 'explorer_close_all',
        [']g'] = 'explorer_git_next',
        ['[g'] = 'explorer_git_prev',
        [']d'] = 'explorer_diagnostic_next',
        ['[d'] = 'explorer_diagnostic_prev',
        [']w'] = 'explorer_warn_next',
        ['[w'] = 'explorer_warn_prev',
        [']e'] = 'explorer_error_next',
        ['[e'] = 'explorer_error_prev',
      },
    },
  },
  -- https://github.com/folke/snacks.nvim/discussions/1306#discussioncomment-12248922
  on_show = function(picker)
    local show = false
    local gap = 1
    local clamp_width = function(value)
      return math.max(20, math.min(100, value))
    end
    --
    local position = picker.resolved_layout.layout.position
    local rel = picker.layout.root
    local update = function(win) ---@param win snacks.win
      local border = win:border_size().left + win:border_size().right
      win.opts.row = vim.api.nvim_win_get_position(rel.win)[1]
      win.opts.height = 0.8
      if position == 'left' then
        win.opts.col = vim.api.nvim_win_get_width(rel.win) + gap
        win.opts.width = clamp_width(vim.o.columns - border - win.opts.col)
      end
      if position == 'right' then
        win.opts.col = -vim.api.nvim_win_get_width(rel.win) - gap
        win.opts.width = clamp_width(vim.o.columns - border + win.opts.col)
      end
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
    rel:on('WinResized', function()
      update(preview_win)
    end)
    picker.preview.win = preview_win
    picker.main = preview_win.win
  end,
  on_close = function(picker)
    picker.preview.win:close()
  end,
  layout = {
    preset = 'sidebar',
    preview = false, ---@diagnostic disable-line
  },
  actions = {
    -- `<A-p>`
    toggle_preview = function(picker) --[[Override]]
      picker.preview.win:toggle()
    end,
  },
}
