local miniopts = function()
  return {
    ai = require('nvim.mini.ai'),
    align = {
      mappings = {
        start = 'gA',
        start_with_preview = 'g|',
      },
    },
    extra = {},
    diff = {
      view = {
        style = 'number',
        -- signs = nv.icons.diff,
        -- signs = { add = '▎', change = '▎', delete = '' },
        -- style = 'sign',
      },
    },
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
    hipatterns = require('nvim.mini.hipatterns'),
    icons = require('nvim.mini.icons'),
    surround = require('nvim.mini.surround'),
    splitjoin = {
      -- TODO: respect shiftwidth
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

-- `src`
-- `:h mini.nvim-buffer-local-config`
-- `:h mini.nvim-disabling-recipes`
local buffer_local_vars = {
  lua = {
    minisurround_config = {
      custom_surroundings = {
        U = { output = { left = 'function()\n', right = '\nend' } },
        u = { output = { left = 'function()\n  ', right = '\nend' } },
        i = {
          output = { left = '-- stylua: ignore start\n', right = '\n-- stylua: ignore end' },
        },
        s = { output = { left = 'vim.schedule(function()\n  ', right = '\nend)' } },
      },
    },
  },
  markdown = {
    minisurround_config = {
      custom_surroundings = {
        -- `saiwL` + [type/paste link] + <CR> - add link
        -- `sdL` - delete link
        -- `srLL` + [type/paste link] + <CR> - replace link
        L = {
          input = { '%[().-()%]%(.-%)' },
          output = function()
            local link = require('mini.surround').user_input('Link: ')
            return { left = '[', right = '](' .. link .. ')' }
          end,
        },
      },
    },
  },
}

local aug = vim.api.nvim_create_augroup('minibufvar', {})
local filetypes = vim.tbl_keys(buffer_local_vars)
vim.api.nvim_create_autocmd('FileType', {
  pattern = filetypes,
  group = aug,
  callback = function(ev)
    for k, v in pairs(buffer_local_vars[ev.match]) do
      vim.b[k] = v
    end
  end,
})

return {
  'nvim-mini/mini.nvim',
  config = function()
    require('mini.misc').setup_termbg_sync()
    for minimod, opts in pairs(miniopts()) do
      require('mini.' .. minimod).setup(opts)
    end
  end,
}

-- vim: fdl=2 fdm=expr
