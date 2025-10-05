return {
  'nvim-treesitter/nvim-treesitter-textobjects',
  branch = 'main',
  event = 'VeryLazy',
  opts = {
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      -- Custom configuration for buffer-local keymaps
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
  config = function(_, opts)
    local TS = require('nvim-treesitter-textobjects')
    if not TS.setup then
      vim.notify('Please update `nvim-treesitter`', vim.log.levels.ERROR)
      return
    end
    TS.setup(opts)

    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('treesitter_textobjects', { clear = true }),
      callback = function(ev)
        -- Check if move is enabled
        if not vim.tbl_get(opts, 'move', 'enable') then
          return
        end
        
        -- Check if treesitter parser and textobjects queries are available for this filetype
        local lang = vim.treesitter.language.get_lang(ev.match) or ev.match
        local has_parser = pcall(vim.treesitter.get_parser, ev.buf, lang)
        local has_queries = has_parser and pcall(vim.treesitter.query.get, lang, 'textobjects')
        
        if not (has_parser and has_queries) then
          return
        end
        ---@type table<string, table<string, string>>
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
}
