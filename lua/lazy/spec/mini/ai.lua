local ai = require('mini.ai')
local mini_ai_opts = {
  n_lines = 500,
  custom_textobjects = {
    c = ai.gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }), -- class
    d = { '%f[%d]%d+' }, -- digits
    e = { -- Word with case
      { '%u[%l%d]+%f[^%l%d]', '%f[%S][%l%d]+%f[^%l%d]', '%f[%P][%l%d]+%f[^%l%d]', '^[%l%d]+%f[^%l%d]' },
      '^().*()$',
    },
    f = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }), -- function
    g = LazyVim.mini.ai_buffer, -- buffer
    o = ai.gen_spec.treesitter({ -- code block
      a = { '@block.outer', '@conditional.outer', '@loop.outer' },
      i = { '@block.inner', '@conditional.inner', '@loop.inner' },
    }),
    u = ai.gen_spec.function_call(), -- u for "Usage"
    U = ai.gen_spec.function_call({ name_pattern = '[%w_]' }), -- without dot in function name
  },
}
require('mini.ai').setup(mini_ai_opts)
require('lazy.spec.mini.ai_whichkey').register(mini_ai_opts)
