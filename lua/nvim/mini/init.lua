-- TODO: See `:h mini.nvim-buffer-local-config` and `:h mini.nvim-disabling-recipes`.
local miniopts = function()
  local ai = require('mini.ai')
  local ex = require('mini.extra')
  local hi = require('mini.hipatterns')
  return {
    ai = {
      n_lines = 500,
      custom_textobjects = {
        -- f = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }), -- function
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
        g = ex.gen_ai_spec.buffer(), -- buffer
        o = ai.gen_spec.treesitter({ -- code block
          a = { '@block.outer', '@conditional.outer', '@loop.outer' },
          i = { '@block.inner', '@conditional.inner', '@loop.inner' },
        }),
        t = { '<([%p%w]-)%f[^<%w][^<>]->.-</%1>', '^<.->().*()</[^/]->$' }, -- tags
        u = ai.gen_spec.function_call(), -- u for "Usage"
        U = ai.gen_spec.function_call({ name_pattern = '[%w_]' }), -- without dot in function name
      },
    },
    align = {
      mappings = {
        start = 'gA',
        start_with_preview = 'g|',
      },
    },
    diff = {
      view = {
        -- style = 'number'
        signs = nv.icons.diff,
        -- signs = { add = '▎', change = '▎', delete = '' },
        style = 'sign',
      },
    },
    extra = {},
    files = {
      content = {
        filter = nil,
        highlight = nil,
        prefix = nil,
        sort = nil,
      },
      mappings = {
        close = 'q',
        go_in = 'l',
        go_in_plus = 'L',
        go_out = 'h',
        go_out_plus = 'H',
        mark_goto = "'",
        mark_set = 'm',
        reset = '<BS>',
        reveal_cwd = '@',
        show_help = 'g?',
        synchronize = '=',
        trim_left = '<',
        trim_right = '>',
      },
      options = {
        permanent_delete = true,
        use_as_default_explorer = false,
      },
      windows = {
        max_number = math.huge,
        preview = false,
        width_focus = 50,
        width_nofocus = 15,
        width_preview = 25,
      },
    },
    hipatterns = {
      highlighters = {
        source_code = nv.source_code_hi,
        hex_color = hi.gen_highlighter.hex_color(),
        --  TODO: don't schedule this setup...
        -- fixme = { pattern = 'FIXME', group = 'MiniHipatternsFixme' },
        -- warning = { pattern = 'WARNING', group = 'MiniHipatternsFixme' },
        -- hack = { pattern = 'HACK', group = 'MiniHipatternsHack' },
        -- section = { pattern = 'Section', group = 'MiniHipatternsHack' },
        -- todo = { pattern = 'TODO', group = 'MiniHipatternsTodo' },
        -- note = { pattern = 'NOTE', group = 'MiniHipatternsNote' },
        -- perf = { pattern = 'PERF', group = 'MiniHipatternsNote' },
      },
    },
    icons = require('nvim.mini.icons'),
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
    },
    splitjoin = {
      -- TODO: remove commas when joining
      mappings = {
        toggle = 'g~',
        split = 'gS',
        join = 'gJ',
      },
      -- Detection options: where split/join should be done
      detect = {
        -- Array of Lua patterns to detect region with arguments.
        -- Default: { '%b()', '%b[]', '%b{}' }
        brackets = nil,
        -- String Lua pattern defining argument separator
        separator = ',',
        -- Array of Lua patterns for sub-regions to exclude separators from.
        -- Enables correct detection in presence of nested brackets and quotes.
        -- Default: { '%b()', '%b[]', '%b{}', '%b""', "%b''" }
        exclude_regions = nil,
      },
    },
  }
end

-- require('mini.misc').setup_termbg_sync()
for minimod, opts in pairs(miniopts()) do
  require('mini.' .. minimod).setup(opts)
end

vim.schedule(function()
  -- Remap adding surrounding to Visual mode selection
  vim.keymap.del('x', 'ys')
  vim.keymap.set('x', 'S', ':<C-u>lua MiniSurround.add("visual")<CR>', { silent = true })

  -- Make special mapping for "add surrounding for line"
  vim.keymap.set('n', 'yss', 'ys_', { remap = true })
  vim.keymap.set('n', '<leader>fm', MiniFiles.open, { desc = 'MiniFiles' })
end)
-- vim: fdl=2
