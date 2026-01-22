local nv = _G.nv or require('nvim')

local M = {
  ['nvim-mini/mini.nvim'] = {
    config = require('nvim.mini').setup,
    toggles = {
      ['<leader>uG'] = {
        name = 'MiniDiff Signs',
        get = function() return vim.g.minidiff_disable ~= true end,
        set = function(state)
          vim.g.minidiff_disable = not state
          MiniDiff.toggle(0)
          nv.defer_redraw_win()
        end,
      },
      ['<leader>go'] = {
        name = 'MiniDiff Overlay',
        get = function()
          local data = MiniDiff.get_buf_data(0)
          return data and data.overlay == true or false
        end,
        set = function(_)
          MiniDiff.toggle_overlay(0)
          nv.defer_redraw_win()
        end,
      },
    },
  },
  ['folke/lazydev.nvim'] = {
    opts = {
      library = {
        { path = 'snacks.nvim', words = { 'Snacks' } },
        { path = 'mini.nvim', words = { 'Mini.*' } },
        { path = 'nvim/util', words = { 'nv' } },
      },
    },
  },
  ['folke/sidekick.nvim'] = {
    ---@type sidekick.Config
    opts = {
      cli = { win = { layout = 'float' } },
    },
    -- stylua: ignore
    keys = {
      { mode = 'n', expr = true, '<Tab>',
        function() return
	  require('sidekick').nes_jump_or_apply() and '' or '<Tab>'
	end
      },
      -- { '<leader>a', group = 'ai', mode = { 'n', 'v' } },
      { '<leader>aa', function() require('sidekick.cli').toggle('copilot') end, desc = 'Sidekick Toggle CLI', },
      { '<leader>aA', function() require('sidekick.cli').toggle() end, desc = 'Sidekick Toggle CLI', },
      { '<leader>ad', function() require('sidekick.cli').close() end, desc = 'Detach a CLI Session', },
      { '<leader>ap', function() require('sidekick.cli').prompt() end, desc = 'Sidekick Select Prompt', mode = { 'n', 'x' }, },
      { '<leader>at', function()
          local msg = vim.fn.mode():sub(1, 1) == 'n' and '{file}' or '{this}'
          require('sidekick.cli').send({ name = 'copilot', msg = msg })
        end, mode = { 'n', 'x' }, desc = 'Send This (file/selection)',
      },
      { '<C-.>', mode = { 'n', 't', 'i', 'x' }, function() require('sidekick.cli').toggle('copilot') end, },
    },
    toggles = {
      ['<leader>uN'] = {
        name = 'Sidekick NES',
        get = function() return require('sidekick.nes').enabled end,
        set = function(state) require('sidekick.nes').enable(state) end,
      },
    },
  },
  ['folke/which-key.nvim'] = {
    enabled = true,
    -- see icon rules at ~/.local/share/nvim/site/pack/core/opt/which-key.nvim/lua/which-key/icons.lua
    config = function()
      local wk = require('which-key')
      wk.setup({
        keys = { scroll_down = '<C-j>', scroll_up = '<C-k>' },
        preset = 'helix',
        replace = {
          desc = {
            -- { '<Plug>%(?(.*)%)?', '%1' },
            { '^%+', '' },
            { '<[cC]md>', ':' },
            { '<[cC][rR]>', '󰌑 ' },
            { '<[sS]ilent>', '' },
            { '^lua%s+', '' },
            { '^lua%s+', '' },
            { '^call%s+', '' },
            -- { '^:%s*', '' },
          },
        },
        show_help = false,
        sort = { 'order', 'alphanum', 'case', 'mod' },
        spec = {
          '<leader>?',
          function() wk.show({ global = false }) end,
          desc = 'Buffer Keymaps (which-key)',
        },
        {
          '<C-w><Space>',
          function() wk.show({ keys = '<C-w>', loop = true }) end,
          desc = 'Window Hydra Mode (which-key)',
        },
      })
    end,
  },
  ['mason-org/mason.nvim'] = {
    opts = { package_installed = '✓', package_pending = '➜', package_uninstalled = '✗' },
    build = vim.cmd.MasonUpdate,
  },
  ['nvim-treesitter/nvim-treesitter'] = {
    build = function()
      vim.cmd(
        ([[TSUpdate | TSInstall! %s]]):format(table.concat(nv.treesitter.parsers.to_install, ' '))
      )
    end,
  },
  ['nvim-treesitter/nvim-treesitter-context'] = {
    toggles = {
      ['<leader>ux'] = {
        name = 'Treesitter Context',
        get = function() return require('treesitter-context').enabled() end,
        set = function() require('treesitter-context').toggle() end,
      },
    },
  },
  ['MeanderingProgrammer/render-markdown.nvim'] = {
    -- TODO: this should be init
    config = function() vim.g.render_markdown_config = nv.md end,
    toggles = {
      ['<leader>um'] = {
        name = 'Render Markdown',
        get = function() return require('render-markdown.state').enabled end,
        set = function(state) require('render-markdown').set(state) end,
      },
    },
  },
  ['R-nvim/R.nvim'] = {
    enabled = false,
    config = function()
      require('r').setup({
        R_args = { '--quiet', '--no-save' },
        -- user_maps_only = true,
        -- quarto_chunk_hl = { highlight = false },
        Rout_more_colors = true,
        hook = {
          -- after_R_start = function() vim.notify('R was launched') end,
          -- after_ob_open = function() vim.notify('Object Browser') end,
        },
      })
    end,
  },
  ['monaqa/dial.nvim'] = {
    config = function() require('plugins.dial') end,
    lazy = true,
  },
  ['Saghen/blink.cmp'] = {
    opts = nv.blink.opts,
    -- event = 'InsertEnter',
    build = 'BlinkCmp build',
  },
}

for _, v in pairs(nv.blink.community_sources) do
  M[v] = { data = v }
end

---@diagnostic disable-next-line: unused-local
local _key_counts = function()
  local ret = {}
  for _, v in pairs(M) do
    if type(v) == 'table' and v ~= M._key_counts then
      for key in pairs(v) do
        ret[key] = (ret[key] or 0) + 1
      end
    end
  end
  return ret
end

return M
-- vim: fdl=1 fdm=expr fdl=5
