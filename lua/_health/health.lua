local M = {}

local start = vim.health.start
local ok = vim.health.ok
local warn = vim.health.warn
local error = vim.health.error

local function ensure_installed(cmd)
  if vim.fn.executable(cmd) == 1 then
    ok(('`%s` is installed'):format(cmd))
  else
    warn(('`%s` is not installed'):format(cmd))
  end
end

function M.check()
  start('My health checks')

  for _, cmd in ipairs({
    'cowsay',
    'fortune',
    'pokeget',
    'quarto',
    'Rscript',
    'tmux',
  }) do
    ensure_installed(cmd)
  end

  local ver = vim.version()
  if ver and not ver.prerelease then
    if ver.major > 0 or ver.minor >= 12 then
      warn('Using Neovim >= 0.12.0, but the prerelease version is recommended')
    else
      error('Neovim >= 0.12.0 is required')
    end
  else
    ok(
      'Using Neovim nightly: '
        .. ver.major
        .. '.'
        .. ver.minor
        .. '.'
        .. ver.patch
        .. ' (build '
        .. ver.build
        .. ')'
    )
  end
end

return M
