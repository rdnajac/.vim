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
    vim.cmd('xmap ga gA') -- preserve normal `ga` for `vim-characterize`
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
          { mode = { 'i', 'c' }, keys = '<C-r>' },
          { mode = { 'n', 'x' }, keys = '"' },
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
  -- extra = {},
  -- files = { options = { use_as_default_explorer = false } },
  icons = function()
    -- HACK: Override get to do wildcard matching
    vim.schedule(function()
      local original_get = _G.MiniIcons.get
      local override = require('nvim.ui.icons').mini_patterns

      ---@diagnostic disable-next-line: duplicate-set-field
      MiniIcons.get = function(category, name)
        local hl
        if vim.endswith(name, '.tmpl') then
          name = name:gsub('%.tmpl$', '')
          hl = 'MiniIconsGrey'
        end
        local basename = vim.fs.basename(name:gsub('dot_', '.'))
        for pattern, spec in pairs(override[category] or {}) do
          -- add anchors to pattern for exact match
          if basename:match('^' .. pattern .. '$') then
            return spec[1], hl or ('MiniIcons' .. spec[2])
          end
        end
        local icon, orig_hl, is_default = original_get(category, name:gsub('dot_', '.'))
        return icon, hl or orig_hl, is_default
      end
    end)

    local function minify(v)
      local glyph = type(v) == 'table' and v[1] or v
      local color = type(v) == 'table' and v[2] or 'Green'
      return { glyph = glyph, hl = 'MiniIcons' .. color }
    end

    return vim.iter(require('nvim.ui.icons').mini):fold({
      use_file_extension = function(ext, _) return ext:sub(-3) ~= 'scm' end,
    }, function(acc, k, v) return rawset(acc, k, vim.tbl_map(minify, v)) end)
  end,
  -- keymap = function()
  --   -- local keymap = require('mini.keymap')
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
  --   -- fix typos in insert mode with `kk`
  --   local action = '<BS><BS><Esc>[s1z=gi<Right>'
  --   keymap.map_combo('i', 'kk', action)
  --   return {}
  -- end,
  hipatterns = function()
    local hi = require('mini.hipatterns')
    local highlighters = { hex_color = hi.gen_highlighter.hex_color() }
    -- local todo = require('nvim.util.todo').mini
    -- highlighters = vim.tbl_extend('keep', highlighters, todo)
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
  -- misc = {},
  -- splitjoin = { mappings = { toggle = 'g~', split = 'gS', join = 'gJ' }, },
  surround = function()
    vim.api.nvim_create_autocmd({ 'FileType' }, {
      pattern = { 'markdown', 'rmd', 'quarto' },
      -- group = aug,
      callback = function()
        vim.b.minisurround_config = {
          L = {
            input = { '%[().-()%]%(.-%)' },
            output = function()
              return {
                left = '[',
                right = string.format('](%s)', _G.MiniSurround.user_input('Link: ')),
              }
            end,
          },
        }
      end,
      desc = 'MiniSurround Markdown Link',
    })
    return {
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
    }
  end,
}

local M = {}

local has_mini_lib = vim.uv.fs_stat(vim.env.PACKDIR .. '/mini.nvim')
M.lazydev = has_mini_lib and { { path = 'mini.nvim', words = { 'Mini.*' } } } or {}
vim.iter(miniopts):each(function(k, v)
  local minimod = 'mini.' .. k
  if not has_mini_lib then
    vim.pack.add({ 'https://github.com/nvim-mini/' .. minimod .. '.git' })
    table.insert(M.lazydev, { path = minimod, words = { 'Mini' .. k:gsub('^%l', string.upper) } })
  end
  require(minimod).setup(vim.is_callable(v) and v() or v)
end)

return M
