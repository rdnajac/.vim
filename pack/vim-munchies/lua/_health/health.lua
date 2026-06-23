local M = {}

local health = vim.health

local function ensure_installed(cmd)
  if vim.fn.executable(cmd) == 1 then
    health.ok(('`%s` is installed'):format(cmd))
  else
    health.warn(('`%s` is not installed'):format(cmd))
  end
end

function M.check()
  health.start('My health checks')
  vim.tbl_map(ensure_installed, {
    'cowsay',
    'fortune',
    'pokeget',
    'quarto',
    'Rscript',
    'tmux',
  })
end

return M
