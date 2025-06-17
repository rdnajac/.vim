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
    'mason-org/mason.nvim',
    build = ':MasonUpdate',
    lazy = false,
    opts = {
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
