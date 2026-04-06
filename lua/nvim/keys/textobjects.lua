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
-- mappings.goto_left = nil
-- mappings.goto_right = nil

---@type wk.Spec[]
return vim.iter(mappings):fold({ mode = { 'o', 'x' } }, function(acc, name, prefix)
  name = name:match('^%a+_(.+)') or name
  acc[#acc + 1] = { prefix, group = name }
  vim.iter(objects):each(function(obj)
    local desc = obj.desc
    if prefix:sub(1, 1) == 'i' then
      desc = desc:gsub(' with ws', '')
    end
    acc[#acc + 1] = { prefix .. obj[1], desc = obj.desc }
  end)
  return acc
end)
