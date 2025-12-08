local ai = require('mini.ai')
local ex = require('mini.extra')

return {
  n_lines = 500,
  custom_textobjects = {
    -- c = ai.gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }), -- class
    -- d = { '%f[%d]%d+' }, -- digits
    d = ex.gen_ai_spec.number,
    e = { -- Word with case
      {
        '%u[%l%d]+%f[^%l%d]',
        '%f[%S][%l%d]+%f[^%l%d]',
        '%f[%P][%l%d]+%f[^%l%d]',
        '^[%l%d]+%f[^%l%d]',
      },
      '^().*()$',
    },
    -- f = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }), -- function
    g = ex.gen_ai_spec.buffer(), -- buffer
    o = ai.gen_spec.treesitter({ -- code block
      a = { '@block.outer', '@conditional.outer', '@loop.outer' },
      i = { '@block.inner', '@conditional.inner', '@loop.inner' },
    }),
    t = { '<([%p%w]-)%f[^<%w][^<>]->.-</%1>', '^<.->().*()</[^/]->$' }, -- tags
    u = ai.gen_spec.function_call(), -- u for "Usage"
    U = ai.gen_spec.function_call({ name_pattern = '[%w_]' }), -- without dot in function name
  },
}
