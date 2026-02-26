local hi = require('mini.hipatterns')
local highlighters = {
  hex_color = hi.gen_highlighter.hex_color(),
}
local todo = require('nvim.util.todo').mini
highlighters = vim.tbl_extend('keep', highlighters, todo)
-- highlights strings in comments wrapped in `backticks`
highlighters.source_code = {
  pattern = '`[^`\n]+`',
  group = function(buf_id, match, data)
    -- convert from 1- to 0-indexed
    local pos = { data.line - 1, data.from_col - 1 }
    local opts = { bufnr = buf_id, pos = pos }
    return nv.is_comment(opts) and 'String' or nil
  end,
  extmark_opts = {
    priority = 10000,
    hl_mode = 'combine',
    spell = false,
  },
}

return { highlighters = highlighters }
