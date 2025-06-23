require('lazy.file')

return {
  {
    'LazyVim/LazyVim',
    priority = 9999,
    -- HACK: override the default LazyVim config entirely
    config = function()
      _G.LazyVim = require('lazyvim.util')
      LazyVim.config = require('lazy.config')
      LazyVim.track('colorscheme')
      require('tokyonight').load()
      LazyVim.track()
      -- LazyVim.on_very_lazy(function()
      --   LazyVim.format.setup()
      --   LazyVim.root.setup()
      -- end)
    end,
  },
  {
    'folke/snacks.nvim',
    priority = 1000,
    ---@module "snacks"
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      -- dashboard = require('lazy.dashboard').config,
      dashboard = { enabled = false },
      explorer = { enabled = false },
      image = { enabled = true },
      indent = { indent = { only_current = true, only_scope = true } },
      input = { enabled = true },
      notifier = { style = 'fancy', date_format = '%T', timeout = 4000 },
      ---@type snacks.picker.Config
      picker = {
        layout = { preset = 'ivy' },
        layouts = {
          ---@type snacks.picker.layout.Config
          mylayout = {
            reverse = true,
            layout = {
              box = 'vertical',
              backdrop = false,
              height = 0.4,
              row = vim.o.lines - math.floor(0.4 * vim.o.lines),
              {
                win = 'list',
                border = 'rounded',
                -- TODO: set titles in picker calls
                title = '{title} {live} {flags}',
                title_pos = 'left',
              },
              {
                win = 'input',
                height = 1,
              },
            },
          },
        },
        sources = {
          commands = {
            confirm = function(picker, item)
              picker:close()
              if item.command then
                local sid = item.command.script_id
                if sid and sid ~= 0 then
                  local src
                  for line in vim.fn.execute('scriptnames'):gmatch('[^\r\n]+') do
                    local id, path = line:match('^%s*(%d+):%s+(.+)$')
                    if tonumber(id) == sid then
                      src = path
                      break
                    end
                  end
                  if src then
                    vim.cmd('edit ' .. src)
                    vim.fn.search('\\<' .. item.cmd .. '\\>', 'w')
                  end
                end
              end
            end,
          },
          notifications = { layout = { preset = 'ivy' } },
          pickers = { layout = { preset = 'ivy' } },
          undo = {
            layout = { preset = 'ivy' },
            -- FIXME: what does this readlly do?
            select = 'copy',
          },
          files = {
            follow = true,
            hidden = false,
            ignored = false,
          },
          recent = {
            filter = {
              paths = {
                [vim.fn.stdpath('data')] = true,
                [vim.fn.stdpath('cache')] = false,
                [vim.fn.stdpath('state')] = false,
              },
            },
          },
          grep = {
            config = function(opts)
              local cwd = opts.cwd or vim.loop.cwd()
              opts.title = '󰱽 Grep (' .. vim.fn.fnamemodify(cwd, ':~') .. ')'
              return opts
            end,
            follow = true,
            ignored = false,
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
        },
        win = {
          input = {
            keys = {
              ['<Esc>'] = { 'close', mode = { 'i', 'n' } },
              ['<a-z>'] = {
                function(self)
                  require('munchies.picker.zoxide').cd_and_resume_picking(self)
                end,
                mode = { 'i', 'n' },
              },
            },
          },
          preview = { minimal = true },
        },
      },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = false },
      styles = {
        lazygit = { height = 0, width = 0 },
      },
      terminal = {
        start_insert = true,
        auto_insert = false,
        auto_close = true,
        win = { wo = { winbar = '', winhighlight = 'Normal:SpecialWindow' } },
      },
      words = { enabled = true },
    },
  },
  {
    'folke/which-key.nvim',
    ---@class wk_opts
    opts = {
      keys = { scroll_down = '<C-j>', scroll_up = '<C-k>' },
      preset = 'helix',
      show_help = false,
      sort = { 'order', 'alphanum', 'case', 'mod' },
      spec = {
        {
          {
            mode = { 'n', 'v' },
            { '[', group = 'prev' },
            { ']', group = 'next' },
            { 'g', group = 'goto' },
            { 'z', group = 'fold' },
          },

          mode = { 'n' },
          {
            '<leader>b',
            group = 'buffer',
            expand = function()
              return require('which-key.extras').expand.buf()
            end,
          },
          {
            '<c-w>',
            group = 'windows',
            expand = function()
              return require('which-key.extras').expand.win()
            end,
          },

          { '<leader>x', group = 'diagnostics/quickfix', icon = { icon = '󱖫 ', color = 'green' } },
          {
            icon = { icon = ' ', color = 'green' },
            { '<leader>E' },
            { '<leader>c', group = 'code' },
            { '<leader>i' },
            { '<leader>m' },
            { '<leader>t' },
            { '<leader>v', group = 'vimrc' },
            { '<leader>w' },
            { '<leader>ft', desc = 'filetype plugin' },
            { '<leader>fs', desc = 'filetype snippets' },
          },
          {
            icon = { icon = '󰢱 ', color = 'blue' },
            { '<leader>fT', desc = 'filetype plugin (.lua)' },
          },
          -- better descriptions
          -- { '<localleader>l', group = 'vimtex' },
          { 'gx', desc = 'Open with system app' },
        },
        { hidden = true, { 'g~' }, { 'g#' }, { 'g*' } },
      },
    },
  },
  -- §: todo-comments
  -- Section:
  {
    'folke/todo-comments.nvim',
    event = 'LazyFile',
    opts = {
      keywords = {
        Section = {
          icon = '§ ',
          color = 'info',
          -- alt = '§',
        },
      },
    },
    -- stylua: ignore
    keys = {
      { ']t', function() require('todo-comments').jump_next() end, desc = 'Next Todo Comment', },
      { '[t', function() require('todo-comments').jump_prtv() end, desc = 'Previous Todo Comment', },
      { "<leader>st", function() Snacks.picker.todo_comments() end, desc = "Todo" },
      { "<leader>sT", function () Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } }) end, desc = "Todo/Fix/Fixme" },
    },
  },
  {
    'github/copilot.vim',
    cmd = 'Copilot',
    event = 'BufWinEnter',
    init = function()
      vim.g.copilot_no_maps = true
      vim.deprecate = function() end -- HACK: remove this once plugin is updated
    end,
    config = function()
      -- Block the normal Copilot suggestions
      vim.api.nvim_create_augroup('github_copilot', { clear = true })
      vim.api.nvim_create_autocmd({ 'FileType', 'BufUnload' }, {
        group = 'github_copilot',
        callback = function(args)
          vim.fn['copilot#On' .. args.event]()
        end,
      })
      vim.fn['copilot#OnFileType']()
    end,
  },
  {
    'nvim-lua/plenary.nvim',
    lazy = true,
  },
  -- TODO: copy this
  { import = 'lazyvim.plugins.extras.util.mini-hipatterns' },
}
