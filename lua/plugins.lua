local nv = _G.nv or require('nvim')
local M = {
  {
    'folke/snacks.nvim',
    ---@type snacks.Config
    opts = {
      bigfile = require('nvim.snacks.bigfile'),
      dashboard = {
        preset = { keys = require('nvim.snacks.dashboard.menu') },
        sections = {
          function() return { header = require('nvim.snacks.dashboard.header')(vim.o.columns) } end,
          { section = 'keys' },
          {
            section = 'terminal',
            cmd = require('nvim.snacks.dashboard.welcome')(),
            indent = 10,
            padding = 1,
            height = 12,
          },
        },
      },
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
    keys = vim
      .iter({ 'extra', 'brackets' })
      :map(function(mod) return require('nvim.keys.' .. mod) end)
      :fold({}, function(acc, src) return vim.list_extend(acc, src) end),
    ---@type table<string, table|string|fun():snacks.toggle.Class|snacks.toggle.Opts>
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
    'nvim-mini/mini.nvim',
    config = function()
      -- require('mini.misc').setup_termbg_sync()
      for modname, opts in pairs({
        ai = function()
          local ai = require('mini.ai')
          local ex = require('mini.extra')
          return {
            n_lines = 500,
            custom_textobjects = {
              -- c = ai.gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }), -- class
              -- d = { '%f[%d]%d+' }, -- digits
              d = ex.gen_ai_spec.number,
              e = { -- Word with case
                {
                  '%u[%l%d]+%f[^%l%d]',
                  '%f[%S][%l%d]+%f[^%l%d]',
                  '%f[%P][%l%d]+%f[^%l%d]',
                  '^[%l%d]+%f[^%l%d]',
                },
                '^().*()$',
              },
              -- f = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }), -- function
              g = ex.gen_ai_spec.buffer(), -- buffer
              o = ai.gen_spec.treesitter({ -- code block
                a = { '@block.outer', '@conditional.outer', '@loop.outer' },
                i = { '@block.inner', '@conditional.inner', '@loop.inner' },
              }),
              t = { '<([%p%w]-)%f[^<%w][^<>]->.-</%1>', '^<.->().*()</[^/]->$' }, -- tags
              u = ai.gen_spec.function_call(), -- u for "Usage"
              U = ai.gen_spec.function_call({ name_pattern = '[%w_]' }), -- without dot in function name
            },
          }
        end,
        align = { mappings = { start = 'gA', start_with_preview = 'g|' } },
        -- comment removed since native commenting added to neovim
        diff = { view = { style = 'number' } },
        extra = {},
        files = { options = { use_as_default_explorer = false } },
        hipatterns = function()
          local hi = require('mini.hipatterns')
          local function in_comment(buf_id, line, col)
            if vim.treesitter.highlighter.active[buf_id] then
              return require('nvim.treesitter').is_comment({ line, col })
            end
            local synid = vim.fn.synID(line + 1, col + 1, 1)
            local name = vim.fn.synIDattr(synid, 'name')
            return name and name:find('Comment') ~= nil
          end
          return {
            highlighters = {
              hex_color = hi.gen_highlighter.hex_color(),
              fixme = { pattern = 'FIXME', group = 'MiniHipatternsFixme' },
              warning = { pattern = 'WARNING', group = 'MiniHipatternsFixme' },
              hack = { pattern = 'HACK', group = 'MiniHipatternsHack' },
              section = { pattern = 'Section', group = 'MiniHipatternsHack' },
              todo = { pattern = 'TODO', group = 'MiniHipatternsTodo' },
              note = { pattern = 'NOTE', group = 'MiniHipatternsNote' },
              perf = { pattern = 'PERF', group = 'MiniHipatternsNote' },
              source_code = { -- highlights strings in comments wrapped in `backticks`
                pattern = '`[^`\n]+`',
                group = function(buf_id, match, data)
                  -- convert from 1- to 0-indexed
                  local line = data.line - 1
                  local col = data.from_col - 1
                  return in_comment(buf_id, line, col) and 'String' or nil
                end,
                extmark_opts = {
                  priority = 10000,
                  hl_mode = 'combine',
                  spell = false,
                },
              },
            },
          }
        end,
        icons = require('nvim.util.icons.mini'),
        -- TODO: keymao for jk escape...
        splitjoin = { mappings = { toggle = 'g~', split = 'gS', join = 'gJ' } }, -- TODO: respect shiftwidth
        surround = {
          mappings = {
            add = 'ys',
            delete = 'ds',
            find = '',
            find_left = '',
            highlight = '',
            replace = 'cs',
            -- Add this only if you don't want to use extended mappings
            suffix_last = '',
            suffix_next = '',
          },
          search_method = 'cover_or_next',
          custom_surroundings = {
            B = { output = { left = '{', right = '}' } },
          },
        },
      }) do
        require('mini.' .. modname).setup(vim.is_callable(opts) and opts() or opts)
      end
    end,
    keys = {
      { '<leader>fm', function() MiniFiles.open() end },
      { '-', function() MiniFiles.open() end },
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
    'folke/which-key.nvim',
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
  {
    'mason-org/mason.nvim',
    opts = {
      package_installed = '✓',
      package_pending = '➜',
      package_uninstalled = '✗',
    },
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
        lualine_a = { nv.blink.status },
      },
      inactive_winbar = {},
    },
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = function()
      vim.cmd(
        ([[TSUpdate | TSInstall! %s]]):format(table.concat(nv.treesitter.parsers.to_install, ' '))
      )
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    toggles = {
      ['<leader>ux'] = {
        name = 'Treesitter Context',
        get = function() return require('treesitter-context').enabled() end,
        set = function() require('treesitter-context').toggle() end,
      },
    },
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    enabled = true,
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
    'monaqa/dial.nvim',
    config = function() require('nvim.keys.dial') end,
    -- event = 'UIEnter',
    -- keys = {
    --   { { 'n', 'x' }, '<C-a>', '<Plug>(dial-increment)' },
    --   { { 'n', 'x' }, '<C-x>', '<Plug>(dial-decrement)' },
    --   { { 'n', 'x' }, 'g<C-a>', '<Plug>(dial-g-increment)' },
    --   { { 'n', 'x' }, 'g<C-x>', '<Plug>(dial-g-decrement)' },
    -- },
  },
  {
    'NStefan002/screenkey.nvim',
    enabled = false,
    opts = function() return require('nvim.keys.opts').screenkey() end,
    toggles = {
      ['<leader>uk'] = {
        name = 'Screenkey floating window',
        get = function() return require('screenkey').is_active() end,
        set = function() return require('screenkey').toggle() end,
      },
      ['<leader>uK'] = {
        name = 'Screenkey statusline component',
        get = function() return require('screenkey').statusline_component_is_active() end,
        set = function() return require('screenkey').toggle_statusline_component() end,
      },
    },
  },
  {
    'Saghen/blink.cmp',
    ---@module "blink.cmp"
    ---@type blink.cmp.Config
    opts = {
      cmdline = { enabled = false },
      completion = {
        accept = { auto_brackets = { enabled = true } },
        documentation = { auto_show = false },
        ghost_text = { enabled = false },
        -- keyword = {},
        list = { selection = { preselect = true, auto_insert = true } },
        trigger = {
          show_on_keyword = true,
          show_on_accept_on_trigger_character = true,
          show_on_x_blocked_trigger_characters = { '"', '(', '{', '[' },
        },
        menu = nv.blink.completion.menu,
      },
      -- fuzzy = { implementation = 'lua' },
      keymap = {
        ['<Tab>'] = {
          function(cmp)
            if cmp.snippet_active() then
              return cmp.accept()
            else
              return cmp.select_and_accept()
            end
          end,
          'snippet_forward',
          function()
            if not package.loaded['sidekick'] then
              return false
            end
            return require('sidekick').nes_jump_or_apply()
          end,
          function() return vim.lsp.inline_completion.get() end,
          'fallback',
        },
      },
      signature = {
        -- enabled = false, -- default = is `true`
        -- window = { show_documentation = false },
        -- TODO: check this
      },
      sources = nv.blink.sources,
    },
    build = 'BlinkCmp build',
    event = 'UIEnter',
  },
}

-- extend blink community sources
for _, v in ipairs(nv.blink.specs) do
  M[#M + 1] = { v }
end

-- add folke ui plugins
vim.list_extend(M, require('folke.specs'))

-- filter plugins early
M = vim.tbl_filter(function(t) return t.enabled ~= false end, M)
-- M = vim.tbl_filter(function(t) return t.enabled == true end, M)

return M
-- vim: fdl=1 fdm=expr
