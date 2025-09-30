local root = vim.fn.fnamemodify('%', ':p:h')

for _, name in ipairs({ 'config', 'data', 'state', 'cache' }) do
  vim.env[('XDG_%s_HOME'):format(name:upper())] = root .. '/' .. name
  -- print(vim.env[('XDG_%s_HOME'):format(name:upper())])
end

vim.pack.add({ 'http://github.com/neovim/neovim.git' }, { confirm = true, load = false })

-- local function gh(user_repo)
--   return 'https://github.com/' .. user_repo .. '.git'
-- end
--
-- local specs = {
--   'folke/tokyonight.nvim',
--   'folke/snacks.nvim',
-- }
-- -- info(vim.tbl_map(gh, specs))
-- vim.pack.add(vim.tbl_map(gh, specs), { confirm = false })
--
-- vim.cmd([[
--   color tokyonight
-- ]])
