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
  icons = require('nvim.util.icons.mini'),
  keymap = function()
    local modes = { 'i', 'c', 'x', 's' }
    local keymap = require('mini.keymap')
    -- FIXME: 
    -- keymap.map_combo(modes, 'jk', '<BS><BS><Esc>')
    -- keymap.map_combo(modes, 'kj', '<BS><BS><Esc>')

    -- Escape into Normal mode from Terminal mode
    keymap.map_combo('t', 'jk', '<BS><BS><C-\\><C-n>')
    keymap.map_combo('t', 'kj', '<BS><BS><C-\\><C-n>')

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
-- vim: fdl=2 fdm=expr
