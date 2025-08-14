local M = {}

M.copilot_icon = function()
  for _, client in pairs(vim.lsp.get_clients()) do
    if client.name == 'GitHub Copilot' then
      return ' '
    end
  end
  return ''
end

M.lsp_icon = function()
  for _, client in pairs(vim.lsp.get_clients()) do
    if client.name ~= 'GitHub Copilot' then
      return ' '
    end
  end
  return ''
end

M.treesitter_icon = function()
  local highlighter = require('vim.treesitter.highlighter')
  local buf = vim.api.nvim_get_current_buf()
  if highlighter.active[buf] then
    return ' '
  end
  return ''
end

function M.docsymbols()
  return require('vimline.docsymbols').get_location()
end

function M.docsymbols_hl()
  return require('vimline.docsymbols').get_location({ apply_hl = true })
end

M.incline_terminal = function(bufnr)
  return '  channel: ' .. vim.o.channel
end

---@param props { buf: number, win: number, focused: boolean }
M.incline = function(props)
  local file = require('vimline.file')
  local bufnr = props.buf or vim.api.nvim_get_current_buf()
  local bufname = vim.api.nvim_buf_get_name(bufnr)
  if bufname:match('^term://') then
    return M.incline_terminal(bufnr)
  end

  local icon = file.type_icon(bufnr)
  local filename = bufname ~= '' and vim.fn.fnamemodify(bufname, ':t') or '[No Name]'
  local modified = file.modified(bufnr)

  -- Always start with base highlight
  local stl = '%#Chromatophore#'

  if props.focused then
    stl = stl .. '' .. '%#Chromatophore_a#'
  end

  stl = stl .. icon .. '  ' .. filename .. modified .. ' '

  return require('incline.helpers').eval_statusline(stl)
end

return M
