local M = {
  {
    'nvim-treesitter/nvim-treesitter',
    build = vim.cmd.TSUpdate,
    -- build = function()
    --   require('nvim-treesitter').update(nil, { summary = true })
    -- end,
    keys = {
      { '<C-Space>', nv.treesitter.selection.start },
      { mode = 'x', '<C-Space>', nv.treesitter.selection.increment },
      { mode = 'x', '<BS>', nv.treesitter.selection.decrement },
    },
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
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
    -- after = function()
    --   local moves = {
    --     goto_next_start = {
    --       [']f'] = '@function.outer',
    --       [']c'] = '@class.outer',
    --       [']a'] = '@parameter.inner',
    --     },
    --     goto_next_end = {
    --       [']F'] = '@function.outer',
    --       [']C'] = '@class.outer',
    --       [']A'] = '@parameter.inner',
    --     },
    --     goto_previous_start = {
    --       ['[f'] = '@function.outer',
    --       ['[c'] = '@class.outer',
    --       ['[a'] = '@parameter.inner',
    --     },
    --     goto_previous_end = {
    --       ['[F'] = '@function.outer',
    --       ['[C'] = '@class.outer',
    --       ['[A'] = '@parameter.inner',
    --     },
    --   }
    --   vim.api.nvim_create_autocmd('FileType', {
    --     group = vim.api.nvim_create_augroup('treesitter_textobjects', {}),
    --     callback = function(ev)
    --       for method, keymaps in pairs(moves) do
    --         for key, query in pairs(keymaps) do
    --           local desc = query:gsub('@', ''):gsub('%..*', '')
    --           desc = desc:sub(1, 1):upper() .. desc:sub(2)
    --           desc = (key:sub(1, 1) == '[' and 'Prev ' or 'Next ') .. desc
    --           desc = desc .. (key:sub(2, 2) == key:sub(2, 2):upper() and ' End' or ' Start')
    --           if not (vim.wo.diff and key:find('[cC]')) then
    --             vim.keymap.set({ 'n', 'x', 'o' }, key, function()
    --               require('nvim-treesitter-textobjects.move')[method](query, 'textobjects')
    --             end, {
    --               buffer = ev.buf,
    --               desc = desc,
    --               silent = true,
    --             })
    --           end
    --         end
    --       end
    --     end,
    --   })
    -- end,
  },
}

return M
