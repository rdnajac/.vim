local aug = vim.api.nvim_create_augroup('treesitter', {})

vim.api.nvim_create_autocmd('FileType', {
  pattern = {
    'css',
    'html',
    'javascript',
    'json',
    'lua',
    'markdown',
    'python',
    'sh',
    'toml',
    'typescript',
    'vim',
    'yaml',
    'zsh',
  },
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

M.install_cli = function()
  if vim.fn.executable('tree-sitter') == 1 then
    return
  end
  -- TODO:  call mason install utility
end

--- Parse position arguments into a vim.pos object
--- @param ... any
---   - no args: use cursor
---   - (int,int): row,col
---   - {int,int}: row,col
--- @return vim.pos
local function get_pos(...)
  local nargs = select('#', ...)
  local pos

  if nargs == 0 then
    pos = vim.pos.cursor(vim.api.nvim_win_get_cursor(0))
  elseif nargs == 1 then
    local arg = select(1, ...)
    if type(arg) == 'table' then
      pos = vim.pos.extmark(arg)
    else
      error('get_pos: single integer is ambiguous, expected {row,col}')
    end
  elseif nargs == 2 then
    pos = vim.pos(...)
  else
    error('get_pos: invalid arguments')
  end

  return pos
end

--- Check if the current node is a comment node
--- @param ... any
---   - no args: use cursor
---   - (int,int): row,col
---   - {int,int}: row,col
--- @return boolean
M.is_comment = function(...)
  local pos = get_pos(...)

  -- HACK: subtract 1 from col to avoid edge cases
  -- pos = vim.pos(pos.row, math.max(0, pos.col - 1)) --[[@cast ]]

  local ok, node = pcall(vim.treesitter.get_node, { bufnr = 0, pos = pos:to_extmark() })
  return ok
      and node
      and vim.tbl_contains({
        'comment',
        'line_comment',
        'block_comment',
        'comment_content',
      }, node:type())
    or false
end

M.status = {
  function()
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
        return nv.icons.filetype[query]
      end, vim.tbl_keys(queries))
    end
    return table.concat(ret, ' ')
  end,
}

return setmetatable(M, {
  __index = function(t, k)
    t[k] = require('nvim.treesitter.' .. k)
    return t[k]
  end,
})
