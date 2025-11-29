return {
  'folke/snacks.nvim',
  ---@module "snacks"
  ---@type snacks.Config
  opts = {
    bigfile = {
      ---@param ctx { buf: number, ft: string }
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
            -- for other files, set the syntax to the detected ft
            local opt = ctx.ft == 'json' and 'filetype' or 'syntax'
            vim.bo[ctx.buf][opt] = ctx.ft
          end
        end)
      end,
    },
    dashboard = require('nvim.snacks.dashboard'),
    explorer = { replace_netrw = false },
    image = { enabled = true },
    indent = { indent = { only_current = true, only_scope = true } },
    input = { enabled = true },
    -- notifier = { enabled = false },
    notifier = require('nvim.snacks.notifier'),
    quickfile = { enabled = true },
    scratch = { template = 'local x = \n\nprint(x)' },
    terminal = { enabled = true },
    scope = {
      keys = {
        textobject = {
          ii = { min_size = 2, edge = false, cursor = false, desc = 'inner scope' },
          ai = { min_size = 2, cursor = false, desc = 'full scope' },
          -- ag = { min_size = 1, edge = false, cursor = false, treesitter = { enabled = false }, desc = "buffer" },
        },
        jump = {
          ['[i'] = { min_size = 1, bottom = false, cursor = false, edge = true },
          [']i'] = { min_size = 1, bottom = true, cursor = false, edge = true },
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
    picker = require('nvim.snacks.picker'),
    styles = {
      lazygit = { height = 0, width = 0 },
      terminal = { wo = { winhighlight = 'Normal:Character' } },
    },
    words = { enabled = true },
  },
  keys = function()
    return require('nvim.snacks.keys')
  end,
}
-- vim: fdl=2
