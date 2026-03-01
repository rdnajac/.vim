local opts = function()
  return {
    ai = require('nvim.mini.ai'),
    align = { mappings = { start = 'gA', start_with_preview = 'g|' } },
    clue = require('nvim.mini.clue'),
    -- comment removed since native commenting added to neovim
    diff = { view = { style = 'number' } },
    extra = {},
    files = { options = { use_as_default_explorer = false } },
    hipatterns = require('nvim.mini.hipatterns'),
    icons = function()
      local opts = {
        directory = {
          ghostty = { '󰊠', 'Green' },
          LazyVim = { '󰒲', 'Blue' },
          ['R.nvim'] = { '󰟔', 'Cyan' },
        },
        extension = {
          fastq = { '󰚄', 'Purple' },
          ['fastq.gz'] = { '󰚄', 'Red' },
          ['json.tmpl'] = { ' ', 'Grey' },
          ['sh.tmpl'] = { ' ', 'Grey' },
          ['toml.tmpl'] = { ' ', 'Grey' },
          ['zsh.tmpl'] = { ' ', 'Grey' },
        },
        file = {
          ['.chezmoiignore'] = { '', 'Grey' },
          ['.chezmoiremove'] = { '', 'Grey' },
          ['.chezmoiroot'] = { '', 'Grey' },
          ['.chezmoiversion'] = { '', 'Grey' },
          ['.keep'] = { '󰊢 ', 'Grey' },
          ['devcontainer.json'] = { '', 'Azure' },
          -- dot_Rprofile = { '󰟔 ', 'Blue' },
          -- dot_bash_aliases = { ' ', 'Blue' },
          -- dot_zprofile = { ' ', 'Green' },
          -- dot_zshenv = { ' ', 'Green' },
          -- dot_zshprofile = { ' ', 'Green' },
          -- dot_zshrc = { ' ', 'Green' },
        },
        filetype = {
          ghostty = { '👻', 'Green' },
          ['nvim-pack'] = { '', 'Green' },
          printf = { '', 'Orange' },
          regex = { '', 'Orange' },
          sidekick_terminal = { ' ', '' },
          snacks_dashboard = { '󰨇 ', '' },
          snacks_terminal = { '🍬', '' },
        },
      }

      local function map_fn(pair) return { glyph = pair[1], hl = 'MiniIcons' .. pair[2] } end

      for opt, v in pairs(opts) do
        opts[opt] = vim.tbl_map(map_fn, v)
      end

      opts.use_file_extension = function(ext, _) return ext:sub(-3) ~= 'scm' end

      local directories_override = {
        ['vim%-.*'] = { '', 'Green' },
        ['lazy.*%.nvim'] = { '󰒲', 'Blue' },
      }

      -- HACK: Override to use wildcard matching for directories
      vim.schedule(function()
        local original_get = MiniIcons.get
        ---@diagnostic disable-next-line: duplicate-set-field
        MiniIcons.get = function(category, name)
          if category == 'directory' then
            local dir = vim.fs.basename(name)
            for pattern, pair in pairs(directories_override) do
              -- add anchors to pattern for exact match
              if dir:match('^' .. pattern .. '$') then
                return pair[1], 'MiniIcons' .. pair[2]
              end
            end
          -- elseif category == 'file' then
          -- name = name:gsub('dot_', '.')
          else
            return original_get(category, name:gsub('dot_', '.'))
          end
        end
      end)

      return opts
    end,
    keymap = function()
      local keymap = require('mini.keymap')
      -- FIXME:
      -- local modes = { 'i', 'c', 'x', 's' }
      -- keymap.map_combo(modes, 'jk', '<BS><BS><Esc>')
      -- keymap.map_combo(modes, 'kj', '<BS><BS><Esc>')
      -- keymap.map_combo('t', 'jk', '<BS><BS><C-\\><C-n>')
      -- keymap.map_combo('t', 'kj', '<BS><BS><C-\\><C-n>')
      local notify_many_keys = function(key)
        local lhs = string.rep(key, 5)
        local action = function() vim.notify('Too many ' .. key) end
        keymap.map_combo({ 'n', 'x' }, lhs, action)
      end
      for _, key in pairs(vim.split('h j k l <Up> <Down> <Left> <Right>', ' ', { plain = true })) do
        notify_many_keys(key)
      end

      -- fix typos in insert mode with `kk`
      local action = '<BS><BS><Esc>[s1z=gi<Right>'
      keymap.map_combo('i', 'kk', action)
      return {}
    end,
    misc = {},
    splitjoin = { mappings = { toggle = 'g~', split = 'gS', join = 'gJ' } }, -- TODO: respect shiftwidth
    -- statusline = { },
    surround = {
      -- mappings = {
      --   add = 'ys',
      --   delete = 'ds',
      --   find = '',
      --   find_left = '',
      --   highlight = '',
      --   replace = 'cs',
      --   -- Add this only if you don't want to use extended mappings
      --   suffix_last = '',
      --   suffix_next = '',
      -- },
      -- search_method = 'cover_or_next',
      custom_surroundings = {
        B = { output = { left = '{', right = '}' } },
      },
    },
  }
end

return {
  after = function() require('mini.misc').log_add('Mini.after()') end,
  -- TODO: make specs work for a single table
  specs = {
    {
      'nvim-mini/mini.nvim',
      config = function()
        local log = require('mini.misc').log_add
        log('Loading mini')
        for modname, opt in pairs(opts()) do
          require('mini.' .. modname).setup(vim.is_callable(opt) and opt() or opt)
        end
        log('Setup mini')
        -- dd(MiniMisc.log_get())
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
            require('nvim.ui').redraw()
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
            require('nvim.ui').redraw()
          end,
        },
      },
    },
  },
}
-- vim: fdl=1 fdm=expr
