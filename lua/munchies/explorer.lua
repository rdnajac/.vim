--- @type snacks.picker.explorer.Config
return {
  win = {
    input = {
      keys = {
        ['<CR>'] = 'jump',
      },
    },
    list = {
      keys = {
        ['/'] = 'picker_grep',
        ['-'] = 'explorer_up',
        ['<Left>'] = 'explorer_up',
        ['<Right>'] = 'confirm',
      },
    },
    preview = { border = 'rounded', focusable = false },
  },
  ignored = true, -- always show git ignored files
  jump = { close = true }, -- close after selecting a file
  on_show = function(self)
    --- show hidden files if the cwd is a chezmoi directory
    if self.opts and self.opts.cwd and self.opts.cwd:match('%/chezmoi') then
      ---@diagnostic disable-next-line: inject-field
      self.opts.hidden = true
    end

    self.layout.wins.preview.layout = false
    -- TODO: cant this be extended to lsp hover for dir?
    --- https://github.com/folke/snacks.nvim/discussions/1306#discussioncomment-12248922
    local root = self.layout.root
    local preview = self.preview.win
    preview.opts.relative = 'editor'

    local update = function()
      local border = preview:border_size()
      preview.opts.row = vim.api.nvim_win_get_position(root.win)[1]
      preview.opts.col = vim.api.nvim_win_get_width(root.win)
      preview.opts.height = 0.8
      preview.opts.width = math.max(20, math.min(100, vim.o.columns - border.left - border.right - preview.opts.col))
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
        if not self:is_focused() then
          self:toggle('preview', { enable = false })
        end
      end)
    end)
  end,
}
