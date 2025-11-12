local M = {}

local lsp_config_dir = vim.fs.joinpath(vim.g.stdpath.config, 'after', 'lsp')
---@type string[]
M.servers = vim.tbl_map(function(path)
  return path:match('^.+/(.+)$'):sub(1, -5)
end, vim.fn.globpath(lsp_config_dir, '*', false, true))

vim.schedule(function()
  vim.lsp.enable(M.servers) -- enable all LSP servers defined in `lsp/`
end)

--- `blink.cmp` will automatically set some capabilities:
--- `capabilities = require('blink.cmp').get_lsp_capabilities()`,
--- see `vim.lsp.protocol.make_client_capabilities()` for nvim's defaults
vim.lsp.config('*', {
  --- @param client vim.lsp.Client
  --- @param bufnr integer
  on_attach = function(client, bufnr)
    -- dd(client.name .. ' attached to buffer ' .. bufnr)
    -- set this manually in case there is another mapping for `K`
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr })
  end,
})

M.spec = {
  { 'neovim/nvim-lspconfig' },
  {
    'mason-org/mason.nvim',
    opts = function()
      return { ui = { icons = nv.icons.mason } }
    end,
    build = vim.cmd.MasonUpdate,
    keys = { { '<leader>cm', '<Cmd>Mason<CR>', desc = 'Mason' } },
  },
  {
    'mason-org/mason-lspconfig.nvim',
    enabled = true,
    lazy = true,
    opts = {
      ensure_installed = {},
      automatic_enable = false,
    },
  },
  -- { 'SmiteshP/nvim-navic' },
  -- { 'b0o/SchemaStore.nvim' },
}

---@param buf? number
M.attached = function(buf)
  vim
    .iter(vim.lsp.get_clients({ bufnr = buf or vim.api.nvim_get_current_buf() }))
    :map(function(c)
      return c.name ~= 'copilot' and c.name or nil
    end)
    :join(', ')
end

return setmetatable(M, {
  __index = function(t, k)
    t[k] = require('nvim.lsp.' .. k)
    return t[k]
  end,
})
