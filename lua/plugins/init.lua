local user_repos = vim.g.vim_plugins or {}

-- your built-in specs:
local specs = {
  { 'folke/lazydev.nvim' },
  { 'folke/tokyonight.nvim' },
  { 'folke/ts-comments.nvim' },
  { 'folke/which-key.nvim' },
  { 'github/copilot.vim', cmd = 'Copilot', event = 'BufWinEnter' },
  { 'nvim-lua/plenary.nvim', lazy = true },
  { 'nvim-treesitter/nvim-treesitter', branch = 'main' },
  { 'xvzc/chezmoi.nvim' },
}

-- append each of your vim-script plugins as { 'owner/repo' } entries
for _, repo in ipairs(user_repos) do
  specs[#specs + 1] = { repo }
end

return specs
