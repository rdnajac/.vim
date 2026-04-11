local miniopts = {
  ai = {
    mappings = {
      around_next = 'aN',
      inside_next = 'iN',
      around_last = 'aL',
      inside_last = 'iL',
    },
  },

  align = function()
    vim.cmd([[ xmap ga gA ]]) -- preserve normal ga
    return { mappings = { start = 'gA', start_with_preview = 'g|' } }
  end,

  clue = function()
    local miniclue = require('mini.clue')
    local clues = { miniclue.gen_clues.builtin_completion() }
    local triggers = { { mode = 'i', keys = '<C-x>' } }
    if not package.loaded['which-key'] then
      for clue, trigger_list in pairs({
        g = { { mode = { 'n', 'x' }, keys = 'g' } },
        marks = {
          { mode = { 'n', 'x' }, keys = "'" },
          { mode = { 'n', 'x' }, keys = '~' },
        },
        registers = {
          { mode = { 'n', 'x' }, keys = '"' },
          { mode = { 'i', 'c' }, keys = '<C-r>' },
        },
        square_brackets = {
          { mode = 'n', keys = '[' },
          { mode = 'n', keys = ']' },
        },
        windows = { { mode = 'n', keys = '<C-w>' } },
        z = { { mode = { 'n', 'x' }, keys = 'z' } },
      }) do
        table.insert(clues, miniclue.gen_clues[clue]())
        vim.list_extend(triggers, trigger_list)
      end
    end
    return {
      clues = clues,
      triggers = triggers,
      window = {
        -- config = {},
        delay = 420,
        scroll_down = '<C-j>',
        scroll_up = '<C-k>',
      },
    }
  end,

  extra = {},

  files = { options = { use_as_default_explorer = false } },

  -- keymap = function()
  --   -- local keymap = require('mini.keymap')
  --   -- FIXME:
  --   -- local modes = { 'i', 'c', 'x', 's' }
  --   -- keymap.map_combo(modes, 'jk', '<BS><BS><Esc>')
  --   -- keymap.map_combo(modes, 'kj', '<BS><BS><Esc>')
  --   -- keymap.map_combo('t', 'jk', '<BS><BS><C-\\><C-n>')
  --   -- keymap.map_combo('t', 'kj', '<BS><BS><C-\\><C-n>')
  --   local notify_many_keys = function(key)
  --     local lhs = string.rep(key, 5)
  --     local action = function() vim.notify('Too many ' .. key) end
  --     keymap.map_combo({ 'n', 'x' }, lhs, action)
  --   end
  --   for _, key in pairs(vim.split('h j k l <Up> <Down> <Left> <Right>', ' ', { plain = true })) do
  --     notify_many_keys(key)
  --   end
  --
  --   -- fix typos in insert mode with `kk`
  --   local action = '<BS><BS><Esc>[s1z=gi<Right>'
  --   keymap.map_combo('i', 'kk', action)
  --   return {}
  -- end,

  hipatterns = function()
    local hi = require('mini.hipatterns')
    local highlighters = { hex_color = hi.gen_highlighter.hex_color() }
    local todo = require('nvim.util.todo').mini
    highlighters = vim.tbl_extend('keep', highlighters, todo)

    highlighters.source_code = {
      pattern = '`[^`\n]+`', -- full match including backticks
      group = function(buf_id, match, data)
        local pos = { data.line - 1, data.from_col - 1 }
        local opts = { bufnr = buf_id, pos = pos }
        if not require('nvim.util').is_comment(opts) then
          return nil
        end

        local ns = vim.api.nvim_create_namespace('source_code_conceal')
        local row = data.line - 1

        -- conceal opening backtick
        vim.api.nvim_buf_set_extmark(buf_id, ns, row, data.from_col - 1, {
          end_col = data.from_col, -- just the one backtick character
          conceal = '',
          priority = 10001,
        })

        -- conceal closing backtick
        vim.api.nvim_buf_set_extmark(buf_id, ns, row, data.to_col - 1, {
          end_col = data.to_col,
          conceal = '',
          priority = 10001,
        })

        return 'Chromatophore'
      end,
      extmark_opts = {
        priority = 10000,
        hl_mode = 'combine',
        spell = false,
      },
    }

    return { highlighters = highlighters }
  end,

  misc = {},

  -- TODO: respect shiftwidth
  splitjoin = {
    -- mappings = { toggle = 'g~', split = 'gS', join = 'gJ' }
  },

  surround = {
    mappings = {
      add = '',
      delete = 'dS',
      find = '',
      find_left = '',
      highlight = '',
      replace = 'cS',
      suffix_last = '',
      suffix_next = '',
    },
    -- search_method = 'cover_or_next',
    custom_surroundings = {
      B = { output = { left = '{', right = '}' } },
    },
  },
}

return {
  'nvim-mini/mini.nvim',
  init = function()
    vim.iter(miniopts):each(
      function(modname, opts)
        require('mini.' .. modname).setup(vim.is_callable(opts) and opts() or opts)
      end
    )
  end,
}
