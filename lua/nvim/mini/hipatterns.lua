local hi = require('mini.hipatterns')

local function in_comment(buf_id, line, col)
  if vim.treesitter.highlighter.active[buf_id] then
    return require('nvim.treesitter').is_comment({ line, col })
  end
  local synid = vim.fn.synID(line + 1, col + 1, 1)
  local name = vim.fn.synIDattr(synid, 'name')
  return name and name:find('Comment') ~= nil
end

return {
  highlighters = {
    hex_color = hi.gen_highlighter.hex_color(),
    -- fixme = { pattern = 'FIXME', group = 'MiniHipatternsFixme' },
    -- warning = { pattern = 'WARNING', group = 'MiniHipatternsFixme' },
    -- hack = { pattern = 'HACK', group = 'MiniHipatternsHack' },
    -- section = { pattern = 'Section', group = 'MiniHipatternsHack' },
    -- todo = { pattern = 'TODO', group = 'MiniHipatternsTodo' },
    -- note = { pattern = 'NOTE', group = 'MiniHipatternsNote' },
    -- perf = { pattern = 'PERF', group = 'MiniHipatternsNote' },
    source_code = { -- highlights strings in comments wrapped in `backticks`
      pattern = '`[^`\n]+`',
      group = function(buf_id, match, data)
        -- convert from 1- to 0-indexed
        local line = data.line - 1
        local col = data.from_col - 1
        return in_comment(buf_id, line, col) and 'String' or nil
      end,
      extmark_opts = {
        priority = 10000,
        hl_mode = 'combine',
        spell = false,
      },
    },
  },
}
