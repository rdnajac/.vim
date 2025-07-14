local hipatterns = require('mini.hipatterns')

hipatterns.setup({
  highlighters = {
    hex_color = hipatterns.gen_highlighter.hex_color(),
    fixme = { pattern = 'FIXME', group = 'MiniHipatternsFixme' },
    warning = { pattern = 'WARNING', group = 'MiniHipatternsFixme' },
    hack = { pattern = 'HACK', group = 'MiniHipatternsHack' },
    section = { pattern = 'Section', group = 'MiniHipatternsHack' },
    todo = { pattern = 'TODO', group = 'MiniHipatternsTodo' },
    note = { pattern = 'NOTE', group = 'MiniHipatternsNote' },
    perf = { pattern = 'PERF', group = 'MiniHipatternsNote' },
  },
})
