local ai = require('mini.ai')

local mini_ai_opts = {
  n_lines = 500,
  custom_textobjects = {
    c = ai.gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }),
    d = { '%f[%d]%d+' }, -- digits
    e = { -- Word with case
      { '%u[%l%d]+%f[^%l%d]', '%f[%S][%l%d]+%f[^%l%d]', '%f[%P][%l%d]+%f[^%l%d]', '^[%l%d]+%f[^%l%d]' },
      '^().*()$',
    },
    f = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }), -- function
    o = ai.gen_spec.treesitter({ -- code block
      a = { '@block.outer', '@conditional.outer', '@loop.outer' },
      i = { '@block.inner', '@conditional.inner', '@loop.inner' },
    }),
    u = ai.gen_spec.function_call(), -- u for "Usage"
    U = ai.gen_spec.function_call({ name_pattern = '[%w_]' }), -- without dot in function name
  },
}

require('mini.ai').setup(mini_ai_opts)

-- local objects = {
--   { ' ', desc = 'whitespace' },
--   { '"', desc = '" string' },
--   { "'", desc = "' string" },
--   { '(', desc = '() block' },
--   { ')', desc = '() block with ws' },
--   { '<', desc = '<> block' },
--   { '>', desc = '<> block with ws' },
--   { '?', desc = 'user prompt' },
--   { '[', desc = '[] block' },
--   { ']', desc = '[] block with ws' },
--   { '_', desc = 'underscore' },
--   { '`', desc = '` string' },
--   { 'a', desc = 'argument' },
--   { 'b', desc = ')]} block' },
--   { 'c', desc = 'class' },
--   { 'd', desc = 'digit(s)' },
--   { 'e', desc = 'CamelCase / snake_case' },
--   { 'f', desc = 'function' },
--   { 'g', desc = 'entire file' },
--   { 'i', desc = 'indent' },
--   { 'o', desc = 'block, conditional, loop' },
--   { 'q', desc = 'quote `"\'' },
--   { 't', desc = 'tag' },
--   { 'u', desc = 'use/call' },
--   { 'U', desc = 'use/call without dot' },
--   { '{', desc = '{} block' },
--   { '}', desc = '{} with ws' },
-- }
--
-- ---@type table<string, string>
-- local mappings = {
--   around = 'a',
--   inside = 'i',
--   around_next = 'an',
--   inside_next = 'in',
--   around_last = 'al',
--   inside_last = 'il',
-- }
-- mappings.goto_left = nil
-- mappings.goto_right = nil
--
-- ---@type wk.Spec[]
-- local ret = { mode = { 'o', 'x' } }
--
-- for name, prefix in pairs(mappings) do
--   name = name:gsub('^around_', ''):gsub('^inside_', '')
--   ret[#ret + 1] = { prefix, group = name }
--   for _, obj in ipairs(objects) do
--     local desc = obj.desc
--     if prefix:sub(1, 1) == 'i' then
--       desc = desc:gsub(' with ws', '')
--     end
--     ret[#ret + 1] = { prefix .. obj[1], desc = obj.desc }
--   end
-- end
--
-- require('which-key').add(ret, { notify = false })
