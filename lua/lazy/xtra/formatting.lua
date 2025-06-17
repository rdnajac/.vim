return {
  {
    'stevearc/conform.nvim',
    dependencies = { 'mason.nvim' },
    lazy = true,
    cmd = 'ConformInfo',
    keys = {
      {
        '<leader>cF',
        function()
          LazyVim.format({ force = true })
        end,
        mode = { 'n', 'v' },
        desc = 'Format',
      },
      {
        '<leader>cF',
        function()
          require('conform').format({ formatters = { 'injected' }, timeout_ms = 3000 })
        end,
        mode = { 'n', 'v' },
        desc = 'Format Injected Langs',
      },
    },
    init = function() end,
    ---@type conform.setupOpts
    opts = function()
      LazyVim.on_very_lazy(function()
        LazyVim.format.register({
          name = 'conform.nvim',
          priority = 100,
          primary = true,
          format = function(buf)
            require('conform').format({ bufnr = buf })
          end,
          sources = function(buf)
            local ret = require('conform').list_formatters(buf)
            ---@param v conform.FormatterInfo
            return vim.tbl_map(function(v)
              return v.name
            end, ret)
          end,
        })
      end)

      return {
        default_format_opts = {
          timeout_ms = 3000,
          async = false, -- not recommended to change
          quiet = false, -- not recommended to change
          lsp_format = 'fallback', -- not recommended to change
        },
        formatters_by_ft = {
          lua = { 'stylua' },
          -- sh = { 'shfmt' },
        },
        -- The options you set here will be merged with the builtin formatters.
        -- You can also define any custom formatters here.
        ---@type table<string, conform.FormatterConfigOverride|fun(bufnr: integer): nil|conform.FormatterConfigOverride>
        formatters = {
          injected = { options = { ignore_errors = true } },
          -- # Example of using shfmt with extra args
          -- shfmt = {
          --   prepend_args = { "-i", "2", "-ci" },
          -- },
        },
      }
    end,
  },
}
