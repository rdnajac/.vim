-- Incremental selection
_G.selected_nodes = {}

local M = {}

M.parsers = {
  -- 'asm',
  'bash',
  -- 'bibtex',
  'csv',
  'cmake',
  'cpp',
  'cuda',
  'comment', -- HACK: this is a custom parser
  'diff',
  'dockerfile',
  'doxygen',
  'git_config',
  'gitcommit',
  'git_rebase',
  'gitattributes',
  'gitignore',
  'gitcommit',
  -- 'groovy',
  'html',
  'javascript',
  'jsdoc',
  'json',
  'jsonc',
  -- 'json5',
  'latex',
  'llvm',
  'luadoc',
  'luap',
  'make',
  'ocaml',
  'printf',
  'python',
  'regex',
  'r',
  'rnoweb',
  'toml',
  'xml',
  'yaml',
}

local function select_node(node)
  if node then
    local start_row, start_col, end_row, end_col = node:range()
    vim.fn.setpos("'<", { 0, start_row + 1, start_col + 1, 0 })
    vim.fn.setpos("'>", { 0, end_row + 1, end_col, 0 })
    vim.cmd('normal! gv')
  end
end

M.start = function()
  _G.selected_nodes = {}
  local current_node = vim.treesitter.get_node()
  if current_node then
    table.insert(_G.selected_nodes, current_node)
    select_node(current_node)
  end
end

M.increment = function()
  local current_node = _G.selected_nodes[#_G.selected_nodes]
  if current_node then
    local parent = current_node:parent()
    if parent then
      table.insert(_G.selected_nodes, parent)
      select_node(parent)
    end
  end
end

M.decrement = function()
  table.remove(_G.selected_nodes)
  local current_node = _G.selected_nodes[#_G.selected_nodes]
  if current_node then
    select_node(current_node)
  end
end

M.register_parser = function()
  vim.api.nvim_create_autocmd('User', {
    pattern = 'TSUpdate',
    callback = function()
      require('nvim-treesitter.parsers').comment = {
        install_info = {
          path = vim.fn.expand('~/GitHub/rdnajac/tree-sitter-comment'),
          -- optional entries:
          -- TODO: track parser in this repo
          -- location = 'parser', -- only needed if the parser is in subdirectory of a "monorepo"
          -- TODO:
          -- generate = true, -- only needed if repo does not contain pre-generated `src/parser.c`
          -- TODO:
          -- generate_from_json = false, -- only needed if repo does not contain `src/grammar.json` either
          -- TODO:
          -- queries = 'queries/neovim', -- also install queries from given directory
        },
      }
    end,
  })
end

-- stylua: ignore
M.setup = function()
M.register_parser()
require('nvim-treesitter').install(M.parsers)

vim.keymap.set('n', '<C-Space>', function() M.start()     end, { desc = 'Start     selection' })
vim.keymap.set('x', '<C-Space>', function() M.increment() end, { desc = 'Increment selection' })
vim.keymap.set('x', '<BS>',      function() M.decrement() end, { desc = 'Decrement selection' })
end

return M
