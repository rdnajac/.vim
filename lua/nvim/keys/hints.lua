local M = {}

M.groups_nv = {
  mode = { 'n', 'v' },
  { '[', group = 'prev' },
  { ']', group = 'next' },
  { 'g', group = 'goto' },
  { 'z', group = 'fold' },
}

M.groups_n = {
  { 'co', group = 'comment below' },
  { 'cO', group = 'comment above' },
  { 'gr', group = 'LSP', icon = { icon = '' } },
  { '<leader>', group = '<leader>' },
  { '<leader>b', group = 'buffers' },
  { '<leader>c', group = 'code' },
  { '<leader>d', group = 'debug' },
  { '<leader>dp', group = 'profiler' },
  { '<leader>f', group = 'file/find' },
  { '<leader>g', group = 'git' },
  { '<leader>s', group = 'search' },
  { '<leader>u', group = 'ui' },
  { '<localleader>l', group = 'vimtex' },
  { '<localleader>r', group = 'R', icon = { icon = ' ', color = 'blue' } },
}

-- TODO: move to dedicated cd plugin
-- local descriptions = {
--   cdc = [[stdpath('config')]],
--   cdC = [[stdpath('cache')]],
--   cdd = [[stdpath('data')]],
--   cds = [[stdpath('state')]],
--   gx = 'Open with system app',
--   ZQ = ':q!',
--   ZZ = ':x',
-- }

return M
