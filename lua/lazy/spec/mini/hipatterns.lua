local hipatterns = require('mini.hipatterns')

hipatterns.setup({
  highlighters = {
    hex_color = hipatterns.gen_highlighter.hex_color(),
    -- TODO:
    -- fixme = { pattern = 'FIXME', group = 'MiniHipatternsFixme' },
    -- hack = { pattern = 'HACK', group = 'MiniHipatternsHack' },
    -- todo = { pattern = 'TODO', group = 'MiniHipatternsTodo' },
    -- note = { pattern = 'NOTE', group = 'MiniHipatternsNote' },
  },
})
