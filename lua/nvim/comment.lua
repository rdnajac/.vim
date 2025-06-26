local function insert_comment(lhs, tag)
  local above = lhs:sub(2, 2) == lhs:sub(2, 2):upper()
  local dir = above and 'above' or 'below'
  local prefix = above and 'O' or 'o'
  local content = tag ~= '' and tag .. ': ' or ''
  local cmd = string.format("%s<Esc>Vc%s¿<Esc>:normal gcc<CR>A<BS>", prefix, content)
  local desc = ('Insert %s comment (%s)'):format(tag ~= '' and tag or 'plain', dir)
  return { lhs, cmd, desc = desc, silent = true }
end

require('which-key').add({
  { 'co', group = 'comment below' },
  { 'cO', group = 'comment above' },
  insert_comment('coo', ''),
  insert_comment('cOo', ''),
  insert_comment('cOO', ''),
  insert_comment('cot', 'TODO'),
  insert_comment('cOt', 'TODO'),
  insert_comment('cof', 'FIXME'),
  insert_comment('cOf', 'FIXME'),
  insert_comment('coh', 'HACK'),
  insert_comment('cOh', 'HACK'),
  insert_comment('cob', 'BUG'),
  insert_comment('cOb', 'BUG'),
  insert_comment('cop', 'PERF'),
  insert_comment('cOp', 'PERF'),
})
