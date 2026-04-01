for modname, opt in pairs({
  ai = function()
    local ai = require('mini.ai')
    local ex = require('mini.extra')
    -- local map_lsp_selection = function(lhs, desc)
    --   local s = vim.startswith(desc, 'Increase') and 1 or -1
    --   local rhs = function() vim.lsp.buf.selection_range(s * vim.v.count1) end
    --   vim.keymap.set('x', lhs, rhs, { desc = desc })
    -- end
    -- map_lsp_selection('<C-Space>', 'Increase selection')
    -- map_lsp_selection('<BS>', 'Decrease selection')
    return {
      mappings = {
        around_next = 'aN',
        inside_next = 'iN',
        around_last = 'aL',
        inside_last = 'iL',
      },
      n_lines = 500,
      custom_textobjects = {
        -- c = ai.gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }), -- class
        -- d = { '%f[%d]%d+' }, -- digits
        -- d = ex.gen_ai_spec.number,
        -- e = { -- Word with case
        --   {
        --     '%u[%l%d]+%f[^%l%d]',
        --     '%f[%S][%l%d]+%f[^%l%d]',
        --     '%f[%P][%l%d]+%f[^%l%d]',
        --     '^[%l%d]+%f[^%l%d]',
        --   },
        --   '^().*()$',
        -- },
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
}) do
  require('mini.' .. modname).setup(vim.is_callable(opt) and opt() or opt)
end

-- MiniMisc.setup_auto_root()
-- MiniMisc.setup_termbg_sync()
