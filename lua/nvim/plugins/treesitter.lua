local aug = vim.api.nvim_create_augroup('treesitter', {})

--- @param ft string|string[] filetype or list of filetypes
--- @param override string|nil optional override parser lang
local autostart = function(ft, override)
  vim.api.nvim_create_autocmd('FileType', {
    pattern = ft,
    group = aug,
    callback = function(args)
      vim.treesitter.start(args.buf, override)
    end,
    desc = 'Automatically start tree-sitter with optional language override',
  })
end

local M = {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      print('Configuring nvim-treesitter')
      autostart({ 'markdown', 'python' })
      autostart({ 'sh', 'zsh' }, 'bash')

      vim.keymap.set('n', '<C-Space>', function()
        require('nvim.util.treesitter.selection').start()
      end, { desc = 'TS Select Node', silent = true })

      vim.keymap.set('x', '<C-Space>', function()
        require('nvim.util.treesitter.selection').increment()
      end, { desc = 'TS Expand Selection', silent = true })

      vim.keymap.set('x', '<BS>', function()
        require('nvim.util.treesitter.selection').decrement()
      end, { desc = 'TS Shrink Selection', silent = true })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    enabled = 'false',
    opts = {
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        -- LazyVim extention to create buffer-local keymaps
        keys = {
          goto_next_start = {
            [']f'] = '@function.outer',
            [']c'] = '@class.outer',
            [']a'] = '@parameter.inner',
          },
          goto_next_end = {
            [']F'] = '@function.outer',
            [']C'] = '@class.outer',
            [']A'] = '@parameter.inner',
          },
          goto_previous_start = {
            ['[f'] = '@function.outer',
            ['[c'] = '@class.outer',
            ['[a'] = '@parameter.inner',
          },
          goto_previous_end = {
            ['[F'] = '@function.outer',
            ['[C'] = '@class.outer',
            ['[A'] = '@parameter.inner',
          },
        },
      },
    },
    after = function(_, opts)
      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('lazyvim_treesitter_textobjects', { clear = true }),
        callback = function(ev)
          ---@type table<string, table<string, string>>
          -- FIXME: move the moves from opts here
          local moves = vim.tbl_get(opts, 'move', 'keys') or {}

          for method, keymaps in pairs(moves) do
            for key, query in pairs(keymaps) do
              local desc = query:gsub('@', ''):gsub('%..*', '')
              desc = desc:sub(1, 1):upper() .. desc:sub(2)
              desc = (key:sub(1, 1) == '[' and 'Prev ' or 'Next ') .. desc
              desc = desc .. (key:sub(2, 2) == key:sub(2, 2):upper() and ' End' or ' Start')
              if not (vim.wo.diff and key:find('[cC]')) then
                vim.keymap.set({ 'n', 'x', 'o' }, key, function()
                  require('nvim-treesitter-textobjects.move')[method](query, 'textobjects')
                end, {
                  buffer = ev.buf,
                  desc = desc,
                  silent = true,
                })
              end
            end
          end
        end,
      })
    end,
  },
}

-- TODO:  report language
M.status = function()
  local highlighter = require('vim.treesitter.highlighter')
  local buf = vim.api.nvim_get_current_buf()
  if highlighter.active[buf] then
    return ' '
  end
  return ''
end

return M
