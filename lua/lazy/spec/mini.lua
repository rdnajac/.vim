return {
  'echasnovski/mini.nvim',
  event = 'VeryLazy',
  init = function()
    package.preload['nvim-web-devicons'] = function()
      require('mini.icons').mock_nvim_web_devicons()
      return package.loaded['nvim-web-devicons']
    end
  end,
  config = function()
    require('mini.align').setup({})
    require('mini.diff').setup({
      view = {
        style = 'sign',
        signs = {
          add = '▎',
          change = '▎',
          delete = '',
        },
      },
    })

    local ai = require('mini.ai')
    local mini_ai_opts = {
      n_lines = 500,
      custom_textobjects = {
        o = ai.gen_spec.treesitter({ -- code block
          a = { '@block.outer', '@conditional.outer', '@loop.outer' },
          i = { '@block.inner', '@conditional.inner', '@loop.inner' },
        }),
        f = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }), -- function
        c = ai.gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }), -- class
        t = { '<([%p%w]-)%f[^<%w][^<>]->.-</%1>', '^<.->().*()</[^/]->$' }, -- tags
        d = { '%f[%d]%d+' }, -- digits
        e = { -- Word with case
          { '%u[%l%d]+%f[^%l%d]', '%f[%S][%l%d]+%f[^%l%d]', '%f[%P][%l%d]+%f[^%l%d]', '^[%l%d]+%f[^%l%d]' },
          '^().*()$',
        },
        g = LazyVim.mini.ai_buffer, -- buffer
        u = ai.gen_spec.function_call(), -- u for "Usage"
        U = ai.gen_spec.function_call({ name_pattern = '[%w_]' }), -- without dot in function name
      },
    }
    require('mini.ai').setup(mini_ai_opts)
    LazyVim.mini.ai_whichkey(mini_ai_opts)

    require('mini.icons').setup({
      file = {
        ['.keep'] = { glyph = '󰊢', hl = 'MiniIconsGrey' },
        ['devcontainer.json'] = { glyph = '', hl = 'MiniIconsAzure' },
        ['dot_zshrc'] = { glyph = '', hl = 'MiniIconsGreen' },
        ['dot_zshenv'] = { glyph = '', hl = 'MiniIconsGreen' },
        ['dot_zprofile'] = { glyph = '', hl = 'MiniIconsGreen' },
        ['dot_zshprofile'] = { glyph = '', hl = 'MiniIconsGreen' },
        ['.chezmoiignore'] = { glyph = '', hl = 'MiniIconsGrey' },
        ['.chezmoiremove'] = { glyph = '', hl = 'MiniIconsGrey' },
        ['.chezmoiroot'] = { glyph = '', hl = 'MiniIconsGrey' },
        ['.chezmoiversion'] = { glyph = '', hl = 'MiniIconsGrey' },
        ['bash.tmpl'] = { glyph = '', hl = 'MiniIconsGrey' },
        ['json.tmpl'] = { glyph = '', hl = 'MiniIconsGrey' },
        ['sh.tmpl'] = { glyph = '', hl = 'MiniIconsGrey' },
        ['toml.tmpl'] = { glyph = '', hl = 'MiniIconsGrey' },
        ['zsh.tmpl'] = { glyph = '', hl = 'MiniIconsGrey' },
      },
      filetype = {
        dotenv = { glyph = '', hl = 'MiniIconsYellow' },
      },
    })

    Snacks.toggle({
      name = 'Mini Diff Signs',
      get = function()
        return vim.g.minidiff_disable ~= true
      end,
      set = function(state)
        vim.g.minidiff_disable = not state
        if state then
          require('mini.diff').enable(0)
        else
          require('mini.diff').disable(0)
        end
        vim.defer_fn(function()
          vim.cmd([[redraw!]])
        end, 200)
      end,
    }):map('<leader>uG')
  end,
    -- stylua: ignore
    keys = {
      { '<leader>go', function() require('mini.diff').toggle_overlay(0) end, desc = 'Toggle mini.diff overlay', },
  },
}
