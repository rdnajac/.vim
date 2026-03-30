---@type snacks.picker.explorer.Config
local M = {
  ignored = true,
  -- override default config function
  config = function(opts)
    local ret = require('snacks.picker.source.explorer').setup(opts)
    if vim.startswith(ret.cwd, vim.g['chezmoi#source_dir_path']) then
      ret.hidden = true
    end
    return ret
  end,
  win = {
    list = {
      keys = {
        ['-'] = 'explorer_up',
        ['<Left>'] = 'explorer_up',
        ['<Right>'] = 'confirm',
        -- ['<CR>'] = { 'jump', 'close' },
      },
    },
  },
}

-- https://github.com/folke/snacks.nvim/discussions/1306#discussioncomment-12248922
local floating_preview_config = {
  -- on picker show
  on_show = function(picker)
    local rel = picker.layout.root
    local clamp_width = function(value) return math.max(20, math.min(100, value)) end

    local update = function(win) ---@param win snacks.win
      local border = win:border_size().left + win:border_size().right
      win.opts.row = vim.api.nvim_win_get_position(rel.win)[1]
      win.opts.height = 0.8
      win.opts.col = vim.api.nvim_win_get_width(rel.win) + 1
      win.opts.width = clamp_width(vim.o.columns - border - win.opts.col)
      win:update()
    end

    local preview_win = Snacks.win.new({
      relative = 'editor',
      external = false,
      focusable = false,
      border = 'rounded',
      backdrop = false,
      show = false,
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

    rel:on('WinResized', function() update(preview_win) end)
    rel:on('WinLeave', function()
      vim.schedule(function()
        if not picker:is_focused() then
          picker.preview.win:close()
        end
      end)
    end)

    picker.preview.win = preview_win
    picker.main = preview_win.win

    -- auto-show preview when opening nvim on a directory
    if vim.fn.argc() == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
      preview_win:show()
    end
  end,
  on_close = function(picker) picker.preview.win:close() end,
  layout = {
    preset = 'sidebar',
    -- preview = false,
  },
  actions = {
    toggle_preview = function(picker) picker.preview.win:toggle() end,
  },
}

vim.tbl_extend('force', M, floating_preview_config)

return M
