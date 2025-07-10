local hipatterns = require('mini.hipatterns')

hipatterns.setup({
  highlighters = {
    hex_color = hipatterns.gen_highlighter.hex_color(),
    fixme = { pattern = 'FIXME', group = 'MiniHipatternsFixme' },
    fixme = { pattern = 'WARNING', group = 'MiniHipatternsFixme' },
    hack = { pattern = 'HACK', group = 'MiniHipatternsHack' },
    hack = { pattern = 'Section', group = 'MiniHipatternsHack' },
    todo = { pattern = 'TODO', group = 'MiniHipatternsTodo' },
    note = { pattern = 'NOTE', group = 'MiniHipatternsNote' },
    note = { pattern = 'PERF', group = 'MiniHipatternsNote' },
  },
})
