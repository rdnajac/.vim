local M = {}

-- taken from MiniExtra.gen_ai_spec.buffer
local ai_spec_buffer = function(ai_type)
  local start_line, end_line = 1, vim.fn.line('$')
  if ai_type == 'i' then
    -- Skip first and last blank lines for `i` textobject
    local first_nonblank, last_nonblank =
      vim.fn.nextnonblank(start_line), vim.fn.prevnonblank(end_line)
    -- Do nothing for buffer with all blanks
    if first_nonblank == 0 or last_nonblank == 0 then
      return { from = { line = start_line, col = 1 } }
    end
    start_line, end_line = first_nonblank, last_nonblank
  end

  local to_col = math.max(vim.fn.getline(end_line):len(), 1)
  return { from = { line = start_line, col = 1 }, to = { line = end_line, col = to_col } }
end

M.opts = function()
  local ai = require('mini.ai')
  local ex = require('mini.extra')
  return {
    n_lines = 500,
    custom_textobjects = {
      f = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }), -- function
      c = ai.gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }), -- class
      d = { '%f[%d]%d+' }, -- digits
      e = { -- Word with case
        {
          '%u[%l%d]+%f[^%l%d]',
          '%f[%S][%l%d]+%f[^%l%d]',
          '%f[%P][%l%d]+%f[^%l%d]',
          '^[%l%d]+%f[^%l%d]',
        },
        '^().*()$',
      },
      g = ai_spec_buffer, -- buffer
      o = ai.gen_spec.treesitter({ -- code block
        a = { '@block.outer', '@conditional.outer', '@loop.outer' },
        i = { '@block.inner', '@conditional.inner', '@loop.inner' },
      }),
      t = { '<([%p%w]-)%f[^<%w][^<>]->.-</%1>', '^<.->().*()</[^/]->$' }, -- tags
      u = ai.gen_spec.function_call(), -- u for "Usage"
      U = ai.gen_spec.function_call({ name_pattern = '[%w_]' }), -- without dot in function name
    },
  }
end

local opts = M.opts()
require('mini.ai').setup(opts)

-- from lazyvim
local objects = {
  { ' ', desc = 'whitespace' },
  { '"', desc = '" string' },
  { "'", desc = "' string" },
  { '(', desc = '() block' },
  { ')', desc = '() block with ws' },
  { '<', desc = '<> block' },
  { '>', desc = '<> block with ws' },
  { '?', desc = 'user prompt' },
  { '[', desc = '[] block' },
  { ']', desc = '[] block with ws' },
  { '_', desc = 'underscore' },
  { '`', desc = '` string' },
  { 'a', desc = 'argument' },
  { 'b', desc = ')]} block' },
  { 'c', desc = 'class' },
  { 'd', desc = 'digit(s)' },
  { 'e', desc = 'CamelCase / snake_case' },
  { 'f', desc = 'function' },
  { 'g', desc = 'entire file' },
  { 'i', desc = 'indent' },
  { 'o', desc = 'block, conditional, loop' },
  { 'q', desc = 'quote `"\'' },
  { 't', desc = 'tag' },
  { 'u', desc = 'use/call' },
  { 'U', desc = 'use/call without dot' },
  { '{', desc = '{} block' },
  { '}', desc = '{} with ws' },
}

---@type table<string, string>
local mappings = {
  around = 'a',
  inside = 'i',
  around_next = 'an',
  inside_next = 'in',
  around_last = 'al',
  inside_last = 'il',
}
mappings.goto_left = nil
mappings.goto_right = nil

---@type wk.Spec[]
local ret = { mode = { 'o', 'x' } }

for name, prefix in pairs(mappings) do
  name = name:gsub('^around_', ''):gsub('^inside_', '')
  ret[#ret + 1] = { prefix, group = name }
  -- print(ret[#ret])
  for _, obj in ipairs(objects) do
    local desc = obj.desc
    if prefix:sub(1, 1) == 'i' then
      desc = desc:gsub(' with ws', '')
    end
    ret[#ret + 1] = { prefix .. obj[1], desc = obj.desc }
    -- print(ret[#ret])
  end
end

require('which-key').add(ret, { notify = false })

return M
