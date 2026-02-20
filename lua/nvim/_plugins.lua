local nv = _G.nv or require('nvim.util')

---@type plug.Spec[]
return {
  {
    'rdnajac/vim-lol',
    enabled = true,
    keys = {
      -- native
      { '<leader>ui', '<Cmd>Inspect<CR>' },
      { '<leader>uI', '<Cmd>Inspect!<CR>' },
      { '<leader>uT', '<Cmd>lua vim.treesitter.inspect_tree(); vim.api.nvim_input("I")<CR>' },
      -- snacks
      { 'dI', 'dai', { desc = 'Delete (Snacks) Indent', remap = true } },
      { ']]', function() Snacks.words.jump(vim.v.count1) end, mode = { 'n', 't' } },
      { '[[', function() Snacks.words.jump(-vim.v.count1) end, mode = { 'n', 't' } },
    },
    ---@type table<string, string|snacks.toggle.Opts>
    toggles = {
      ['<leader>ac'] = 'autochdir',
      ['<leader>dpp'] = 'profiler',
      ['<leader>dph'] = 'profiler_highlights',
      ['<leader>ua'] = 'animate',
      ['<leader>ud'] = 'diagnostics',
      ['<leader>uD'] = 'dim',
      ['<leader>ug'] = 'indent',
      ['<leader>uh'] = 'inlay_hints',
      ['<leader>ul'] = 'line_number',
      ['<leader>uS'] = 'scroll',
      ['<leader>ut'] = 'treesitter',
      ['<leader>uW'] = 'words',
      ['<leader>uZ'] = 'zoom',
      ['<leader>us'] = 'spell',
      ['<leader>uL'] = 'relativenumber',
      ['<leader>uw'] = 'wrap',
      ['<leader>uv'] = {
        name = 'Virtual Text',
        get = function() return vim.diagnostic.config().virtual_text ~= false end,
        set = function(state) vim.diagnostic.config({ virtual_text = state }) end,
      },
      ['<leader>ub'] = {
        name = 'Translucency',
        get = function() return Snacks.util.is_transparent() end,
        set = function(state)
          local bg = Snacks.util.color('Normal', 'bg') or '#24283B'
          Snacks.util.set_hl({ Normal = { bg = state and 'none' or bg } })
          vim.api.nvim_exec_autocmds('ColorScheme', { modeline = false })
        end,
      },
      ['<leader>uu'] = {
        name = 'LastStatus',
        get = function() return vim.o.laststatus > 0 end,
        set = function(state)
          if not state then
            vim.w.lastlaststatus = vim.o.laststatus
            vim.o.laststatus = 0
          else
            vim.o.laststatus = vim.w.lastlaststatus or 2
          end
        end,
      },
      ['<leader>u\\'] = {
        name = 'ColorColumn',
        get = function()
          ---@diagnostic disable-next-line: undefined-field
          local cc = vim.opt_local.colorcolumn:get()
          local tw = vim.bo.textwidth
          local col = tostring(tw ~= 0 and tw or 81)
          return vim.tbl_contains(cc, col)
        end,
        set = function(state)
          local tw = vim.bo.textwidth
          local col = tostring(tw ~= 0 and tw or 81)
          vim.opt_local.colorcolumn = state and col or ''
        end,
      },
    },
  },
  {
    'mason-org/mason.nvim',
    build = vim.cmd.MasonUpdate,
    opts = { ui = { icons = require('nvim.util.icons').mason.emojis } },
  },
  {
    'folke/lazydev.nvim',
    opts = {
      -- integrations = { cmp = false },
      library = {
        { path = 'snacks.nvim', words = { 'Snacks' } },
        { path = 'mini.nvim', words = { 'Mini.*' } },
        { path = 'nvim', words = { 'nv' } },
      },
    },
  },
  {
    'folke/sidekick.nvim',
    enabled = false,
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
  {
    'nvim-mini/mini.nvim',
    config = function()
      -- require('mini.misc').setup_termbg_sync()
      local mini_opts = require('nvim.mini')
      for modname, opts in pairs(mini_opts) do
        require('mini.' .. modname).setup(vim.is_callable(opts) and opts() or opts)
      end
    end,
    keys = {
      { '<leader>fm', function() MiniFiles.open() end },
      -- { '-', function() MiniFiles.open() end },
    },
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
  {
    'R-nvim/R.nvim',
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
  {
    'chrisgrieser/nvim-scissors',
    -- opts = {},
  },
  {
    'stevearc/oil.nvim',
    enabled = true,
    keys = { { '-', '<Cmd>Oil<CR>' } },
    opts = {
      default_file_explorer = false,
    },
  },
}
