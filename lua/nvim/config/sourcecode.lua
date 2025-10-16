-- highlights `src` in backticks ( ` )
local ns = vim.api.nvim_create_namespace('src')

local function in_comment(lnum, s_col)
  if vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()] then
    return nv.treesitter.is_comment({ lnum, s_col })
  end
  local synid = vim.fn.synID(lnum + 1, s_col + 1, 1)
  local name = vim.fn.synIDattr(synid, 'name')
  return name and name:find('Comment') ~= nil
end

local function highlight_line(bufnr, lnum, line)
  vim.api.nvim_buf_clear_namespace(bufnr, ns, lnum, lnum + 1)

  local s_col = 0
  while true do
    local s, e = line:find('`[^`\n]+`', s_col + 1)
    if not s then
      break
    end

    -- highlight inside comment only
    if in_comment(lnum, s - 1) then
      vim.api.nvim_buf_set_extmark(bufnr, ns, lnum, s - 1, {
        end_col = e,
        hl_group = 'Chromatophore',
        hl_mode = 'combine',
        spell = false,
        priority = 10000,
      })
    end
    s_col = e
  end
end

local function highlight_backticks(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  for lnum, line in ipairs(lines) do
    highlight_line(bufnr, lnum - 1, line)
  end
end

local M = {}

function M.setup()
  if vim.bo[0].filetype ~= 'bigfile' then
    highlight_backticks()
  end
  vim.api.nvim_create_autocmd('BufEnter', {
    nested = true,
    callback = function(args)
      if vim.bo[args.buf].filetype == 'bigfile' then
        return
      end
      highlight_backticks(args.buf)

      vim.api.nvim_create_autocmd({ 'TextChanged', 'TextChangedI' }, {
        buffer = args.buf,
        callback = function(a)
          local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
          local line = vim.api.nvim_buf_get_lines(a.buf, lnum, lnum + 1, false)[1]
          if line then
            highlight_line(a.buf, lnum, line)
          end
        end,
      })
    end,
  })
end

return M
