local nv = _G.nv or require('nvim.util')

---@type Plugin[]
return {
  {
    'folke/snacks.nvim',
    ---@type snacks.Config
    opts = {
      bigfile = require('nvim.snacks.bigfile'),
      dashboard = require('nvim.snacks.dashboard'),
      explorer = { replace_netrw = true },
      image = { enabled = true },
      indent = { indent = { only_current = false, only_scope = true } },
      input = { enabled = true },
      -- notifier = require('nvim.snacks.notifier'),
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
      statuscolumn = require('nvim.snacks.statuscolumn'),
      picker = require('nvim.snacks.picker'),
      styles = {
        lazygit = { height = 0, width = 0 },
        terminal = { wo = { winhighlight = 'Normal:Character' } },
        notification_history = { height = 0.9, width = 0.9, wo = { wrap = false } },
      },
      words = { enabled = true },
    },
    keys = {
      { 'dI', 'dai', { desc = 'Delete (Snacks) Indent', remap = true } },
      { ']]', function() Snacks.words.jump(vim.v.count1) end, mode = { 'n', 't' } },
      { '[[', function() Snacks.words.jump(-vim.v.count1) end, mode = { 'n', 't' } },
    },
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
    },
  },
  {
    'rdnajac/vim-lol',
    enabled = true,
    keys = {
      { '<leader>ui', '<Cmd>Inspect<CR>' },
      { '<leader>uI', '<Cmd>Inspect!<CR>' },
      { '<leader>uT', '<Cmd>lua vim.treesitter.inspect_tree(); vim.api.nvim_input("I")<CR>' },
    },
    ---@type table<string, snacks.toggle.Opts>
    toggles = {
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
    'folke/lazydev.nvim',
    opts = {
      -- integrations = { cmp = false },
      library = {
        { path = 'snacks.nvim', words = { 'Snacks' } },
        { path = 'mini.nvim', words = { 'Mini.*' } },
        { path = 'nvim/util', words = { 'nv' } },
      },
    },
  },
  {
    'folke/sidekick.nvim',
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
    'mason-org/mason.nvim',
    opts = { ui = { icons = nv.icons.mason.emojis } },
    build = vim.cmd.MasonUpdate,
  },
  {
    'nvim-lualine/lualine.nvim',
    enabled = false,
    -- `https://github.com/nvim-lualine/lualine.nvim/wiki/Component-snippets`
    opts = {
      options = {
        component_separators = { left = '', right = '' },
        -- section_separators = nv.icons.sep.section.rounded,
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
          statusline = { pattern = 'snacks_dashboard' },
          -- winbar = { 'netrw', 'snacks_dashboard', 'snacks_picker_list', 'snacks_picker_input' },
          tabline = { 'snacks_dashboard' },
        },
        ignore_focus = {
          -- 'man',
          -- 'help',
        },
        -- theme = {
        --   normal = { a = 'Chromatophore_a', b = 'Chromatophore_b', c = 'Chromatophore_c' },
        -- },
        -- use_mode_colors = false,
      },
      extensions = { 'man' },
      sections = {},
      inactive_sections = {},
      tabline = {},
      winbar = {
        -- lualine_a = { require('nvim.util.status').buffer },
        -- lualine_a = { nv.blink.status },
      },
      inactive_winbar = {},
    },
  },
  {
    'nvim-mini/mini.nvim',
    config = function()
      -- require('mini.misc').setup_termbg_sync()
      require('mini')
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
    'MeanderingProgrammer/render-markdown.nvim',
    init = function()
      ---@module "render-markdown"
      ---@type render.md.UserConfig
      vim.g.render_markdown_config = {
        file_types = { 'markdown', 'rmd', 'quarto' },
        latex = { enabled = false },
        bullet = { right_pad = 1 },
        -- checkbox = { enabled = false },
        completions = { blink = { enabled = false } },
        code = {
          -- TODO: fix the highlights and show ` or spaces for inline code markers
          -- inline_left = ' ',
          -- inline_right = ' ',
          -- inline_padding= 1,
          enabled = true,
          highlight = '',
          highlight_border = false,
          -- highlight_inline = 'Chromatophore',
          -- render_modes = { 'n', 'c', 't', 'i' },
          sign = false,
          conceal_delimiters = false,
          language = true,
          position = 'left',
          language_icon = true,
          language_name = false,
          language_info = false,
          width = 'block',
          min_width = 0,
          border = 'thin',
          style = 'normal',
        },
        heading = {
          sign = false,
          width = 'full',
          position = 'overlay',
          -- left_pad = { 0, 1, 2, 3, 4, 5 },
          -- icons = '',
        },
        html = {
          comment = { conceal = false },
          enabled = false,
        },
      }
    end,
    toggles = {
      ['<leader>um'] = {
        name = 'Render Markdown',
        get = function() return require('render-markdown.state').enabled end,
        set = function(state) require('render-markdown').set(state) end,
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
}

-- vim: fdm=expr fdl=1
