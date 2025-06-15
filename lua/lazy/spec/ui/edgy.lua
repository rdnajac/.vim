return {
  'folke/edgy.nvim',
  enabled = false,
  event = 'VeryLazy',
    -- stylua: ignore
    keys = {
    -- TODO: snacks toggle
      { '<leader>ue', function() require('edgy').toggle() end, desc = 'Edgy Toggle', },
      { '<leader>uE', function() require('edgy').select() end, desc = 'Edgy Select Window', },
    },
  opts = function()
    local opts = {
      exit_when_last = true,
      -- animate = { enabled = false },
      -- options = { bottom = { size = 20 } },
      -- bottom = {
      --   { ft = 'help', filter = function(buf) return vim.bo[buf].buftype == 'help' end },
      --   { ft = 'man',  filter = function(buf) return vim.bo[buf].buftype == 'man'  end },
      -- }
      ---@type (Edgy.View.Opts|string)[]
      left = {
        {
          title = 'Oil',
          ft = 'oil',
          filter = function(buf, win)
            return vim.api.nvim_win_get_config(win).relative == ''
            -- or vim.bo[buf].filetype == 'oil'
          end,
          -- pinned = true,
          -- collapsed = true,
          -- open = 'Oil',
          -- open = 'vsplit +Oil',
          size = { width = 30 },
        },
      },
      -- stylua: ignore
      keys = {
        ['<c-Right>'] = function(win) win:resize('width',  2) end,
        ['<c-Left>']  = function(win) win:resize('width', -2) end,
        ['<c-Up>']    = function(win) win:resize('height', 2) end,
        ['<c-Down>']  = function(win) win:resize('height',-2) end,
      },
    }

    -- snacks terminal
    for _, pos in ipairs({ 'top', 'bottom', 'left', 'right' }) do
      opts[pos] = opts[pos] or {}
      table.insert(opts[pos], {
        ft = 'snacks_terminal',
        size = { height = 0.4 },
        title = '%{b:snacks_terminal.id}: %{b:term_title}',
        filter = function(_buf, win)
          return vim.w[win].snacks_win
            and vim.w[win].snacks_win.position == pos
            and vim.w[win].snacks_win.relative == 'editor'
            and not vim.w[win].trouble_preview
        end,
      })
    end
    return opts
  end,
}
