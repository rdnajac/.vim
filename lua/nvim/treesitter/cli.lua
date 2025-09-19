---@class lazyvim.util.treesitter
local M = {}

M._installed = nil ---@type table<string,string>?

---@param update boolean?
function M.get_installed(update)
  if update then
    M._installed = {}
    for _, lang in ipairs(require('nvim-treesitter').get_installed('parsers')) do
      M._installed[lang] = lang
    end
  end
  return M._installed or {}
end

-- try installing with mason
if not pcall(require, 'mason') then
  return fail('`mason.nvim` is disabled in your config, so we cannot install it automatically.')
end

-- check again since we might have installed it already
if vim.fn.executable('tree-sitter') == 1 then
  return 
end

local mr = require('mason-registry')
mr.refresh(function()
  local p = mr.get_package('tree-sitter-cli')
  if not p:is_installed() then
    LazyVim.info('Installing `tree-sitter-cli` with `mason.nvim`...')
    p:install(
      nil,
      vim.schedule_wrap(function(success)
        if success then
          LazyVim.info('Installed `tree-sitter-cli` with `mason.nvim`.')
          cb()
        else
          fail('Failed to install `tree-sitter-cli` with `mason.nvim`.')
        end
      end)
    )
  end
end)

return M
