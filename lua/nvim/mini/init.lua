-- TODO:
-- > e7a8e5a0 │ feat(base16): add 'folke/snacks.nvim' integration
-- > 126a9a99 │ feat(hues): add 'folke/snacks.nvim' integration
return {
  spec = {
    {
      'nvim-mini/mini.nvim',
      config = function()
        -- require('mini.misc').setup_termbg_sync()
        for minimod, opts in pairs({
          ai = require('nvim.mini.ai'),
          align = { mappings = { start = 'gA', start_with_preview = 'g|' } },
          diff = { view = { style = 'number' } },
          extra = {},
          hipatterns = require('nvim.mini.hipatterns'),
          icons = require('nvim.mini.icons'),
          splitjoin = require('nvim.mini.splitjoin'),
          surround = require('nvim.mini.surround'),
        }) do
          -- call set up for each available module
          require('mini.' .. minimod).setup(opts)
        end

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
      end,
      toggles = {
        ['<leader>uG'] = {
          name = 'MiniDiff Signs',
          get = function() return vim.g.minidiff_disable ~= true end,
          set = function(state)
            vim.g.minidiff_disable = not state
            MiniDiff.toggle(0)
            nv.defer_redraw_win()
          end,
        },
        ['<leader>go'] = {
          name = 'MiniDiff Overlay',
          get = function()
            local data = MiniDiff.get_buf_data(0)
            return data and data.overlay == true or false
          end,
          set = function(_)
            MiniDiff.toggle_overlay(0)
            nv.defer_redraw_win()
          end,
        },
      },
    },
  },
}
