local miniopts = {
  ai = require('nvim.mini.ai'),
  align = { mappings = { start = 'gA', start_with_preview = 'g|' } },
  extra = {},
  diff = { view = { style = 'number' } },
  files = require('nvim.mini.files'),
  hipatterns = require('nvim.mini.hipatterns'),
  icons = require('nvim.mini.icons'),
  splitjoin = require('nvim.mini.splitjoin'),
  surround = require('nvim.mini.surround'),
}

-- call set up for each available module
for minimod, opts in pairs(miniopts) do
  require('mini.' .. minimod).setup(opts)
end

require('mini.misc').setup_termbg_sync()

-- `src`
-- `:h mini.nvim-buffer-local-config`
-- `:h mini.nvim-disabling-recipes`
local buffer_local_configs = {
  lua = {
    minisurround_config = {
      custom_surroundings = {
        u = { output = { left = 'function() ', right = ' end' } },
        U = { output = { left = 'function()\n', right = '\nend' } },
        i = {
          output = { left = '-- stylua: ignore start\n', right = '\n-- stylua: ignore end' },
        },
        s = {
          input = { '%[%[().-()%]%]' },
          output = { left = '[[', right = ']]' },
        },
        S = { output = { left = 'vim.schedule(function()\n  ', right = '\nend)' } },
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
local filetypes = vim.tbl_keys(buffer_local_configs)
vim.api.nvim_create_autocmd('FileType', {
  pattern = filetypes,
  group = aug,
  callback = function(ev)
    for k, v in pairs(buffer_local_configs[ev.match]) do
      vim.b[k] = v
    end
  end,
  desc = 'Set buffer-local configs for mini.nvim modules',
})
