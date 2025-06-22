local function insert_comment(lhs, text)
  local above = lhs:sub(-1) == lhs:sub(-1):upper()
  local dir = above and 'above' or 'below'
  local prefix = above and 'O' or 'o'
  local cmd = string.format('%s<Esc>Vc%s¿<Esc>:normal gcc<CR>A<BS>', prefix, text and text .. ': ' or '')
  local description = ('Insert %s (%s)'):format(text ~= '' and text or 'comment', dir)

  return { lhs, cmd, desc = description, silent = true }
end

-- FIXME: don't clobber gc
-- require('which-key')({
--   { 'gc', group = 'comments' },
--   insert_comment('gco', ''),
--   insert_comment('gcO', ''),
--   insert_comment('gct', 'TODO'),
--   insert_comment('gcT', 'TODO'),
--   insert_comment('gcf', 'FIXME'),
--   insert_comment('gcF', 'FIXME'),
--   insert_comment('gch', 'HACK'),
--   insert_comment('gcH', 'HACK'),
--   insert_comment('gcb', 'BUG'),
--   insert_comment('gcB', 'BUG'),
-- })
