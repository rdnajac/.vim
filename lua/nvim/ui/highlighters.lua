-- mini highlighters
local M = {}
-- local todo = require('nvim.util.todo').mini
-- highlighters = vim.tbl_extend('keep', highlighters, todo)
M.source_code = {
  pattern = '`[^`\n]+`', -- full match including backticks
  group = function(buf_id, match, data)
    -- TODO: use vim.pos
    local pos = { data.line - 1, data.from_col - 1 }
    local opts = { bufnr = buf_id, pos = pos }
    if not require('nvim.util').is_comment(opts) then
      return nil
    end

    local ns = vim.api.nvim_create_namespace('source_code_conceal')
    local row = data.line - 1

    -- conceal opening backtick
    vim.api.nvim_buf_set_extmark(buf_id, ns, row, data.from_col - 1, {
      end_col = data.from_col, -- just the one backtick character
      conceal = '',
      priority = 10001,
    })

    -- conceal closing backtick
    vim.api.nvim_buf_set_extmark(buf_id, ns, row, data.to_col - 1, {
      end_col = data.to_col,
      conceal = '',
      priority = 10001,
    })

    return 'Chromatophore'
  end,
  extmark_opts = {
    priority = 10000,
    hl_mode = 'combine',
    spell = false,
  },
}

return M
