local groups = require('folke.tokyonight.gen.groups')
for group, hl in pairs(groups) do
  hl = type(hl) == 'string' and { link = hl } or hl
  vim.api.nvim_set_hl(0, group, hl)
end
