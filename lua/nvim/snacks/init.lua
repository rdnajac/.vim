return {
  ---@module "snacks"
  'folke/snacks.nvim',
  ---@type snacks.Config
  opts = {
    bigfile = {
      ---@param ctx {buf: number, ft:string}
      setup = function(ctx)
        vim.b.completion = false
        vim.b.minihipatterns_disable = true
        if vim.fn.exists(':NoMatchParen') == 2 then
          vim.cmd.NoMatchParen()
        end
        vim.cmd.setlocal('foldmethod=manual', 'statuscolumn=', 'conceallevel=0')
        -- Snacks.util.wo(0, { foldmethod = 'manual', statuscolumn = '', conceallevel = 0 })
        vim.schedule(function()
          if vim.api.nvim_buf_is_valid(ctx.buf) then
            -- for json files, keep the filetype as json
            -- for other files, set the syntax to the detected filetype
            vim.bo[ctx.buf][ctx.ft == 'json' and 'filetype' or 'syntax'] = ctx.ft
          end
        end)
      end,
    },
    dashboard = require('nvim.snacks.dashboard'),
    explorer = { replace_netrw = false },
    image = { enabled = true },
    indent = { indent = { only_current = true, only_scope = true } },
    input = { enabled = true },
    notifier = { enabled = false },
    -- notifier = require('nvim.snacks.notifier'),
    quickfile = { enabled = true },
    -- scratch = { template = 'local x = \n\nprint(x)' },
    terminal = { enabled = true },
    scope = {
      keys = {
        textobject = {
          ii = { min_size = 2, edge = false, cursor = false, desc = 'inner scope' },
          ai = { min_size = 2, cursor = false, desc = 'full scope' },
          -- ag = { min_size = 1, edge = false, cursor = false, treesitter = { enabled = false }, desc = "buffer" },
        },
        jump = {
          ['[i'] = {
            min_size = 1,
            bottom = false,
            cursor = false,
            edge = true,
            desc = 'jump to top edge of scope',
          },
          [']i'] = {
            min_size = 1,
            bottom = true,
            cursor = false,
            edge = true,
            desc = 'jump to bottom edge of scope',
          },
        },
      },
    },
    scroll = { enabled = true },
    -- statuscolumn = { enabled = false },
    statuscolumn = {
      left = { 'mark', 'sign' }, -- priority of signs on the left (high to low)
      right = { 'fold', 'git' }, -- priority of signs on the right (high to low)
      folds = {
        open = false, -- show open fold icons
        git_hl = false, -- use Git Signs hl for fold icons
      },
    },
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
      -- layout = { preset = 'mydefault' },
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
        git_status = { layout = 'left' },
        grep = require('nvim.snacks.picker.defaults'),
        icons = { layout = { preset = 'insert' } },
        recent = {
          config = function(p)
            p.filter = {}
          end,
        },
        zoxide = { confirm = 'edit' },
      },
    },
    styles = {
      dashboard = { wo = { winhighlight = 'WinBar:NONE' } },
      -- sidebar = { wo = { winhighlight = 'WinBar:NONE' } },
      lazygit = { height = 0, width = 0 },
      -- TODO: fix colors
      terminal = { wo = { winbar = '', winhighlight = 'Normal:Character' } },
    },
    words = { enabled = true },
  },
  keys = function()
    return require('nvim.snacks.keys')
  end,
  after = function()
    require('nvim.snacks.commands')
    require('nvim.snacks.toggles')
  end,
}
-- vim: fdl=2
