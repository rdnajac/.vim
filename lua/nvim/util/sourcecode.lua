-- Highlight text enclosed in `backticks` within comments
local ns = vim.api.nvim_create_namespace('src')

local function get_comment_prefix()
  local cs = vim.bo.commentstring
  if not cs or cs == '' then
    return nil
  end
  -- extract prefix before %s
  local prefix = cs:match('^(.*)%%s')
  if prefix then
    return vim.trim(prefix)
  end
  return nil
end

local function highlight_backticks(bufnr)
  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

  local prefix = get_comment_prefix()
  if not prefix then
    return
  end

  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  for lnum, line in ipairs(lines) do
    if vim.startswith(vim.trim(line), prefix) then
      for start_col, text in line:gmatch('()`([^`]+)`()') do
        local s_col = start_col - 1
        local e_col = s_col + #text + 2 -- include backticks
        vim.api.nvim_buf_set_extmark(bufnr, ns, lnum - 1, s_col, {
          end_col = e_col,
          hl_group = 'Chromatophore',
          hl_mode = 'combine',
        })
      end
    end
  end
end

vim.api.nvim_create_autocmd({ 'BufEnter', 'TextChanged', 'TextChangedI' }, {
  callback = function(args)
    highlight_backticks(args.buf)
  end,
})
