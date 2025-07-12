local user_repos = vim.g.vim_plugins or {}

local specs = {
  { 'nvim-lua/plenary.nvim', lazy = true },
  { 'folke/tokyonight.nvim' },
  { 'folke/ts-comments.nvim' },
  { 'github/copilot.vim', cmd = 'Copilot', event = 'BufWinEnter' },
  { 'nvim-treesitter/nvim-treesitter', branch = 'main' },
  { 'xvzc/chezmoi.nvim' },
}

for _, repo in ipairs(user_repos) do
  specs[#specs + 1] = { repo }
end

return specs
