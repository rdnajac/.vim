---@module "snacks"
---@type snacks.Config
return {
  -- bigfile = { enabled = true },
bigfile = {
  ---@param ctx {buf: number, ft:string}
  setup = function(ctx)
    if vim.fn.exists(":NoMatchParen") ~= 0 then
      vim.cmd([[NoMatchParen]])
    end
    Snacks.util.wo(0, { foldmethod = "manual", statuscolumn = "", conceallevel = 0 })
    vim.b.minianimate_disable = true
    vim.schedule(function()
      if vim.api.nvim_buf_is_valid(ctx.buf) then
        vim.bo[ctx.buf].syntax = ctx.ft
      end
    end)
  end,
},
  dashboard = require('nvim.snacks.dashboard'),
  explorer = { replace_netrw = false }, -- using `oil` instead
  image = { enabled = true },
  indent = { indent = { only_current = true, only_scope = true } },
  input = { enabled = true },
  notifier = { enabled = false },
  -- notifier = require('nvim.snacks.notifier'),
  quickfile = { enabled = true },
  scratch = { template = 'local x = \n\nprint(x)' },
  terminal = { enabled = true },
  scope = { enabled = true },
  scroll = { enabled = true },
  statuscolumn = { enabled = false },
  picker = {
    debug = {
      -- scores = true, -- show scores in the list
      -- leaks = true, -- show when pickers don't get garbage collected
      -- explorer = true, -- show explorer debug info
      -- files = true, -- show file debug info
      -- grep = true, -- show file debug info
      -- proc = true, -- show proc debug info
      -- extmarks = true, -- show extmarks errors
    },
    layout = { preset = 'mydefault' },
    layouts = require('nvim.snacks.picker.layouts'),
    sources = {
      buffers = {
        input = {
          keys = {
            ['<c-x>'] = { 'bufdelete', mode = { 'n', 'i' } },
          },
        },
        list = { keys = { ['D'] = 'bufdelete' } },
      },
      explorer = require('nvim.snacks.picker.explorer'),
      autocmds = require('nvim.snacks.picker.nvimcfg'),
      keymaps = require('nvim.snacks.picker.nvimcfg'),
      files = require('nvim.snacks.picker.defaults'),
      grep = require('nvim.snacks.picker.defaults'),
      icons = { layout = { preset = 'insert' } },
      zoxide = { confirm = 'edit' },
    },
  },
  styles = {
    dashboard = { wo = { winhighlight = 'WinBar:NONE' } },
    lazygit = { height = 0, width = 0 },
    terminal = { wo = { winbar = '', winhighlight = 'Normal:Character' } },
  },
  words = { enabled = true },
}
