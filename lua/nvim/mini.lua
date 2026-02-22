return {
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
  clue = function()
    local gen = require('mini.clue').gen_clues
    local clues, triggers = {}, {}
    for clue, trigger_list in pairs({
      builtin_completion = {
        { mode = 'i', keys = '<C-x>' },
      },
      g = {
        { mode = { 'n', 'x' }, keys = 'g' },
      },
      marks = {
        { mode = { 'n', 'x' }, keys = "'" },
        { mode = { 'n', 'x' }, keys = '`' },
      },
      registers = {
        { mode = { 'n', 'x' }, keys = '"' },
        { mode = { 'i', 'c' }, keys = '<C-r>' },
      },
      square_brackets = {
        { mode = 'n', keys = '[' },
        { mode = 'n', keys = ']' },
      },
      windows = {
        { mode = 'n', keys = '<C-w>' },
      },
      z = {
        { mode = { 'n', 'x' }, keys = 'z' },
      },
    }) do
      table.insert(clues, gen[clue]())
      vim.list_extend(triggers, trigger_list)
    end

    return {
      clues = clues,
      triggers = triggers,
      -- { mode = { 'n', 'x' }, keys = '<Leader>' },
      window = {
        -- config = {},
        -- delay = 1000,
        scroll_down = '<C-j>',
        scroll_up = '<C-k>',
      },
    }
  end,
  -- comment removed since native commenting added to neovim
  diff = { view = { style = 'number' } },
  extra = {},
  files = { options = { use_as_default_explorer = false } },
  hipatterns = function() -- `works`
    local hi = require('mini.hipatterns')
    return {
      -- TODO: move to nvim.util.todo
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
            return nv.is_comment(buf_id, line, col) and 'String' or nil
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
        dot_Rprofile = { '󰟔 ', 'Blue' },
        dot_bash_aliases = { ' ', 'Blue' },
        dot_zprofile = { ' ', 'Green' },
        dot_zshenv = { ' ', 'Green' },
        dot_zshprofile = { ' ', 'Green' },
        dot_zshrc = { ' ', 'Green' },
        -- ['ghostty/config'] = { '👻', 'Green' },
      },

      filetype = {
        dotenv = { ' ', 'Yellow' },
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
        end
        return original_get(category, name)
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

    -- fix typos in insert mode
    local action = '<BS><BS><Esc>[s1z=gi<Right>'
    keymap.map_combo('i', 'kk', action)
    return {}
  end,
  splitjoin = { mappings = { toggle = 'g~', split = 'gS', join = 'gJ' } }, -- TODO: respect shiftwidth
  -- statusline = { },
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
}
-- vim: fdl=1 fdm=expr
