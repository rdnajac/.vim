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

local function mason_install()
  local tools = lang_spec.tools
  local total = #tools
  local completed = 0

  local function done()
    completed = completed + 1
    if completed == total then
      Snacks.notify.info('All tools checked.')
    end
  end

  for _, tool in ipairs(tools) do
    local ok, pkg = pcall(require('mason-registry').get_package, tool)
    if not ok then
      Snacks.notify.error('Tool not found in mason registry: ' .. tool)
      done()
    else
      if pkg:is_installed() then
        done()
        goto continue
      end

      Snacks.notify.warn('Installing ' .. tool)

      pkg:once('install:success', function()
        Snacks.notify.info(tool .. ' installed successfully')
        done()
      end)
      pkg:once('install:failed', function()
        Snacks.notify.error(tool .. ' installation failed')
        done()
      end)

      pkg:install()
    end
    ::continue::
  end
end

return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    branch = 'main',
    build = ':TSUpdate',
    config = function()
      local aug = vim.api.nvim_create_augroup('treesitter', { clear = true })

      local filetypes = { 'vim', 'sh', 'tex', 'markdown',  }

      vim.api.nvim_create_autocmd('FileType', {
        group = aug,
        pattern = filetypes,
        callback = function()
          vim.treesitter.start()
        end,
      })

      vim.api.nvim_create_autocmd('User', {
        pattern = 'TSUpdate',
        group = aug,
        callback = function()
          -- Use custom parser that highlights strings in `backticks` in comments
          require('nvim-treesitter.parsers').comment = {
            install_info = {
              url = 'https://github.com/rdnajac/tree-sitter-comment',
              generate = true,
              queries = 'queries/neovim',
            },
          }
        end,
      })

      -- XXX: deprecated, don't use LazyVim
      LazyVim.on_very_lazy(function()
        local ensure_installed = require('nvim.treesitter.parsers')
        require('nvim-treesitter').install(ensure_installed)
      end)
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
    init = function()
      vim.api.nvim_create_user_command('InstallTools', function()
        mason_install()
      end, { desc = 'Install tools from mason.nvim' })
    end,
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
