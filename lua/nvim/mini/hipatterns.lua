local hi = require('mini.hipatterns')

return {
  -- TODO: move to nvim.util.todo
  highlighters = {
    hex_color = hi.gen_highlighter.hex_color(),
    bug = { pattern = 'BUG', group = 'MiniHipatternsFixme' },
    fixme = { pattern = 'FIXME', group = 'MiniHipatternsFixme' },
    warning = { pattern = 'WARN', group = 'MiniHipatternsHack' },
    xxx = { pattern = 'XXX', group = 'MiniHipatternsHack' },
    hack = { pattern = 'HACK', group = 'MiniHipatternsHack' },
    section = { pattern = 'Section', group = 'MiniHipatternsHack' },
    todo = { pattern = 'TODO', group = 'MiniHipatternsTodo' },
    note = { pattern = 'NOTE', group = 'MiniHipatternsNote' },
    perf = { pattern = 'PERF', group = 'Identifier' },
    source_code = { -- highlights strings in comments wrapped in `backticks`
      pattern = '`[^`\n]+`',
      group = function(buf_id, match, data)
        -- convert from 1- to 0-indexed
        local line = data.line - 1
        local col = data.from_col - 1
        return nv.is_comment(buf_id, line, col) and 'String' or nil
      end,
      extmark_opts = {
        priority = 10000,
        hl_mode = 'combine',
        spell = false,
      },
    },
  },
}
