-- highlights `src` in backticks ( ` )
local ns = vim.api.nvim_create_namespace('src')

local in_comment = function(lnum, s_col)
  if vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()] then
    return nv.treesitter.is_comment({ lnum, s_col })
  else
    local synid = vim.fn.synID(lnum + 1, s_col + 1, 1)
    local name = vim.fn.synIDattr(synid, 'name')
    return name and name:find('Comment') ~= nil
  end
end

local function highlight_line(bufnr, lnum, line)
  vim.api.nvim_buf_clear_namespace(bufnr, ns, lnum, lnum + 1)

  if not line:match('`.*`') then
    return
  end

  for start_col, text in line:gmatch('()`([^`\n]+)`()') do
    local s_col = start_col - 1
    local e_col = s_col + #text + 2

    if in_comment(lnum, s_col) then
      vim.api.nvim_buf_set_extmark(bufnr, ns, lnum, s_col, {
        end_col = e_col,
        hl_group = 'Chromatophore',
        hl_mode = 'combine',
        spell = false,
        priority = 10000,
      })
    end
  end
end

local function highlight_backticks(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  for lnum, line in ipairs(lines) do
    highlight_line(bufnr, lnum - 1, line)
  end
end

local M = {}

M.setup = function()
  vim.api.nvim_create_autocmd('BufEnter', {
    nested = true,
    callback = function(args)
      if vim.bo[args.buf].filetype == 'bigfile' then
        return
      end
      highlight_backticks(args.buf)

      -- register another autocmd
      vim.api.nvim_create_autocmd({ 'TextChanged', 'TextChangedI' }, {
        callback = function(args)
          local cursor = vim.api.nvim_win_get_cursor(0)
          local lnum = cursor[1] - 1
          local line = vim.api.nvim_buf_get_lines(args.buf, lnum, lnum + 1, false)[1]
          if line then
            highlight_line(args.buf, lnum, line)
          end
        end,
      })
    end,
  })
end

return M
