---@module "snacks"
---@type snacks.picker.sources.Config|{}|table<string, snacks.picker.Config|{}>
return {
  explorer = require('plugins.snacks.explorer'),
  files = {
    config = function(opts)
      local cwd = opts.cwd or vim.loop.cwd()
      ---@diagnostic disable-next-line: param-type-mismatch
      opts.title = ' Find [ ' .. vim.fn.fnamemodify(cwd, ':~') .. ' ]'
      return opts
    end,
    follow = true,
    matcher = { frecency = true },
    hidden = false,
    ignored = false,
    actions = {
      toggle = function(self)
        require('munchies.picker').toggle(self)
      end,
    },
  },
  grep = {
    config = function(opts)
      local cwd = opts.cwd or vim.loop.cwd()
      ---@diagnostic disable-next-line: param-type-mismatch
      opts.title = '󰱽 Grep (' .. vim.fn.fnamemodify(cwd, ':~') .. ')'
      return opts
    end,
    follow = true,
    hidden = false,
    ignored = false,
    actions = {
      toggle = function(self)
        require('munchies.picker').toggle(self)
      end,
    },
  },
  icons = {
    layout = {
      layout = {
        reverse = true,
        relative = 'cursor',
        row = 1,
        width = 0.3,
        min_width = 48,
        height = 0.3,
        border = 'none',
        box = 'vertical',
        { win = 'input', height = 1, border = 'rounded' },
        { win = 'list', border = 'rounded' },
      },
    },
  },
}
