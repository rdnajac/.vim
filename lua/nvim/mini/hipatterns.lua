local hi = require('mini.hipatterns')
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
    source_code = nv.source_code_hi,
  },
}
