local M = {}

-- PERF: does it matter that these are scheduled?
M.after = function()
  -- delay loading this table until after init
  M.parsers = require('nvim.treesitter.parsers')

  local aug = vim.api.nvim_create_augroup('treesitter', {})
  vim.api.nvim_create_autocmd('FileType', {
    pattern = M.parsers.to_autostart,
    group = aug,
    callback = function(ev) vim.treesitter.start(ev.buf) end,
    desc = 'Automatically start tree-sitter',
  })
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'markdown', 'r', 'rmd', 'quarto' },
    group = aug,
    command = 'setlocal foldmethod=expr foldexpr=v:lua.vim.treesitter.foldexpr()',
    desc = 'Use treesitter folding for select filetypes',
  })
end

-- TODO: remove when native ts selection is merged
M.selection = require('nvim.treesitter.selection')

M.specs = {
  {
    'nvim-treesitter/nvim-treesitter',
    build = function() vim.cmd('TSUpdate') end,
    -- TODO: Don't re-install up-to-date parsers
    -- build = function() vim.cmd('TSUpdate | TSInstall! ' .. table.concat(M.parsers.to_install, ' ')) end,
    keys = {
      { 'n', '<C-Space>', M.selection.start, { desc = 'Start ts selection' } },
      { 'x', '<C-Space>', M.selection.increment, { desc = 'Increment ts selection' } },
      { 'x', '<BS>', M.selection.decrement, { desc = 'Decrement ts selection' } },
    },
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    enabled = false,
    toggles = {
      ['<leader>ux'] = {
        name = 'Treesitter Context',
        get = function() return require('treesitter-context').enabled() end,
        set = function() require('treesitter-context').toggle() end,
      },
    },
  },
  -- require('nvim.treesitter.textobjects'),
}

---@type table<string,string>?
M._installed = nil

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

M.status = function()
  local ret = {}
  local highlighter = require('vim.treesitter.highlighter')
  local hl = highlighter.active[vim.api.nvim_get_current_buf()]
  ---@diagnostic disable-next-line: invisible
  local queries = hl and hl._queries
  if type(queries) == 'table' then
    ret = vim.tbl_map(function(query)
      if query == vim.bo.filetype then
        return ' '
      end
      return require('nvim.ui.icons').filetype[query]
    end, vim.tbl_keys(queries))
  end
  return table.concat(ret, ' ')
end

M.install_cli = function()
  if vim.fn.executable('tree-sitter') == 1 then
    return
  end
  -- TODO: use mason install utility
end

local _is_comment = {
  comment = true,
  line_comment = true,
  block_comment = true,
  comment_content = true,
}

M.node_is_comment = function(node) return _is_comment[node:type()] == true end

return M
