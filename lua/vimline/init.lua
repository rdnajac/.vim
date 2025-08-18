local M = {}

function M.docsymbols()
  return require('vimline.docsymbols').get_location()
end

M.ft_icon = function()
  return require('vimline.file').ft_icon()
end

M.diagnostics = function()
  return package.loaded['vim.diagnostic'] and vim.diagnostic.status() or ''
end

-- TODO: add icons from nvim icons
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


---@param props { buf: number, win: number, focused: boolean }
M.incline = function(props)
  local file = require('vimline.file')
  local bufnr = props.buf or vim.api.nvim_get_current_buf()
  local bufname = vim.api.nvim_buf_get_name(bufnr)
  local buftype = vim.bo[bufnr].buftype

  if buftype == 'terminal' then
    return '  channel: ' .. vim.o.channel
  elseif vim.bo[bufnr].filetype == 'help' then
    local bufname = vim.api.nvim_buf_get_name(bufnr)
    if bufname == '' then
      -- Fallback to the buffer's "help topic" name
      bufname = vim.api.nvim_buf_get_var(bufnr, 'current_syntax') or '[No Name]'
    end
    -- For help files, `:t` works fine if bufname is a real path, but if not, just use bufname
    local filename = bufname:match('[^/\\]+$') or bufname
    return '󰋖 ' .. filename
  end

  local icon = file.type_icon(bufnr)
  local filename = bufname ~= '' and vim.fn.fnamemodify(bufname, ':t') or '[No Name]'
  local modified = file.modified(bufnr)
end

return M
