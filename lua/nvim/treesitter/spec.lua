return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = function()
      local parsers = require('nvim.treesitter.parsers')
      vim.cmd('TSUpdate | TSInstall! ' .. table.concat(parsers, ' '))
    end,
    keys = function()
      local selection = require('nvim.treesitter.selection')
      return {
        { '<C-Space>', selection.start },
        { '<C-Space>', selection.increment, mode = 'x' },
        { '<BS>', selection.decrement, mode = 'x' },
      }
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main', -- TODO: should be updated soon
    enabled = false,
    opts = {
      move = { set_jumps = true },
      select = {
        lookahead = true,
        selection_modes = {
          ['@parameter.outer'] = 'v', -- charwise
          ['@function.outer'] = 'V', -- linewise
          ['@class.outer'] = '<c-v>', -- blockwise
        },
        include_surrounding_whitespace = false,
      },
    },
    keys = function()
      -- You can also use captures from other query groups like `locals.scm`
      -- vim.keymap.set({ 'x', 'o' }, 'as', function()
      -- require('nvim-treesitter-textobjects.select').select_textobject('@local.scope', 'locals')
      -- end)
      local function select_textobject(textobject)
        return require('nvim-treesitter-textobjects.select').select_textobject(
          textobject,
          'textobjects'
        )
      end
      -- stylua: ignore
      return {
	mode = { 'x', 'o' },
	{'af', function() select_textobject('@function.outer') end,},
	{'if', function() select_textobject('@function.inner') end,},
	{'ac', function() select_textobject('@class.outer') end,},
	{'ic', function() select_textobject('@class.inner') end,},
      }
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    -- opts = {
    --   max_lines = 0,
    --   min_window_height = 0,
    --   line_numbers = true,
    --   multiline_threshold = 20,
    --   trim_scope = 'outer', -- Choices: 'inner', 'outer'
    --   mode = 'cursor', -- Choices: 'cursor', 'topline'
    --   -- Separator between context and content. Should be a single character string, like '-'.
    --   -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
    --   separator = nil,
    --   zindex = 20, -- The Z-index of the context window
    --   on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
    -- },
    toggles = {
      ['<leader>ux'] = {
        name = 'Treesitter Context',
        get = function() return require('treesitter-context').enabled() end,
        set = function() require('treesitter-context').toggle() end,
      },
    },
  },
}
