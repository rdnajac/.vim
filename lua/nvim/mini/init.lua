-- TODO:
-- > e7a8e5a0 │ feat(base16): add 'folke/snacks.nvim' integration
-- > 126a9a99 │ feat(hues): add 'folke/snacks.nvim' integration
-- `:h mini.nvim-buffer-local-config`
-- `:h mini.nvim-disabling-recipes`

local M = {}

M.opts = {
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
  diff = { view = { style = 'number' } },
  extra = {},
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
  icons = require('nvim.mini.icons'),
  -- TODO: respect shiftwidth
  splitjoin = {
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
  surround = function()
    vim.schedule(function()
      -- vim.keymap.del('x', 'ys')
      vim.keymap.set('x', 'S', [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true })
      vim.keymap.set('n', 'yss', 'ys_', { remap = true, desc = 'surround line' })
    end)
    return {
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
    }
  end,
}

M.setup = function()
  -- require('mini.misc').setup_termbg_sync()
  for minimod, opts in pairs(M.opts) do
    -- call set up for each available module
    opts = vim.is_callable(opts) and opts() or opts
    require('mini.' .. minimod).setup(opts)
  end
end

return M
-- vim: fdl=1 fdm=expr
