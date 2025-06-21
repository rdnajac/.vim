_G.lang_spec = setmetatable({
  tools = {},
  lsps = {},
}, {
  __newindex = function(t, k, v)
    local items = type(v[1]) == 'table' and v or { v }
    for _, item in ipairs(items) do
      local tool, lsp = item[1] or item, item[2]
      table.insert(t.tools, tool)
      if lsp then
        table.insert(t.lsps, lsp)
      end
    end
    rawset(t, k, v)
  end,
})

_G.langsetup = setmetatable({}, {
  __call = function(_, entries)
    local key = debug.getinfo(2, 'S').source:match('([^/\\]+)%.lua$')
    _G.lang_spec[key] = entries
  end,
})

return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    branch = 'main',
    build = ':TSUpdate',
    config = function()
      local ensure_installed = require('nvim.treesitter').parsers
      require('nvim-treesitter').install(ensure_installed)
    end,
    keys = function()
      local sel = require('nvim.treesitter.selection')
      -- stylua: ignore
      return {
        { '<C-Space>', function() sel.start() end, mode = 'n', desc = 'Start selection' },
        { '<C-Space>', function() sel.increment() end, mode = 'x', desc = 'Increment selection' },
        { '<BS>', function() sel.decrement() end, mode = 'x', desc = 'Decrement selection' },
      }
    end,
  },
  {
    'folke/ts-comments.nvim',
    event = 'VeryLazy',
    opts = {},
  },
  {
    'mason-org/mason.nvim',
    build = ':MasonUpdate',
    lazy = false,
    opts = {
      -- PERF:
      -- ui = {
      --   icons = {
      --     package_installed = '✓',
      --     package_pending = '➜',
      --     package_uninstalled = '✗',
      --   },
      -- },
    },
  },
}
