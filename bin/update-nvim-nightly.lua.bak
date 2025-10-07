#!/usr/bin/env -S nvim -l

local URL = 'https://github.com/neovim/neovim/releases/download/nightly/nvim-macos-arm64.tar.gz'
local TARPATH = vim.fs.joinpath(vim.fn.stdpath('run'), URL:match('([^/]+)$'))
local DATA_HOME = vim.env.XDG_DATA_HOME or vim.fs.joinpath(vim.env.HOME, '.local', 'share')
local INSTALL_DIR = vim.fs.joinpath(DATA_HOME, 'nvim')
local LOCALBIN = vim.fs.joinpath(vim.env.HOME, '.local', 'bin')

vim.fn.mkdir(INSTALL_DIR, 'p')
vim.fn.mkdir(LOCALBIN, 'p')

local res = vim.api.nvim_exec2('version', { output = true }).output or ''
local old_version = res:match('^NVIM v([^\n]+)') or 'unknown'
print('👾 Upgrading Neovim from ' .. old_version .. ' to nightly...')

local wget = require('nvim.util.wget')

wget(URL, {
  outpath = TARPATH,
  create_dirs = true,
  force = true,
})

local function run(cmd)
  print('→ Running: ' .. table.concat(cmd, ' '))
  local result = vim.system(cmd, { text = true }):wait()
  if result.code ~= 0 then
    io.stderr:write('✗ Failed: ' .. table.concat(cmd, ' ') .. '\n')
    if result.stderr and result.stderr ~= '' then
      io.stderr:write(result.stderr .. '\n')
      -- print(result.stderr .. '\n')
    end
    error('Aborted.')
  end
  if result.stdout and result.stdout ~= '' then
    print(result.stdout)
  end
  print('✓ OK: ' .. table.concat(cmd, ' '))
  return result
end

run({ 'xattr', '-c', TARPATH })
run({ 'rm', '-rf', INSTALL_DIR .. '/bin' })
run({ 'rm', '-rf', INSTALL_DIR .. '/lib' })
run({ 'rm', '-rf', INSTALL_DIR .. '/share' })
run({
  'tar',
  '-xzf',
  TARPATH,
  '-C',
  INSTALL_DIR,
  '--strip-components=1',
})
run({ 'ln', '-sfv', INSTALL_DIR .. '/bin/nvim', LOCALBIN .. '/nvim' })
run({ 'rm', '-fv', TARPATH })

local result = run({ LOCALBIN .. '/nvim', '--version' })
local new_version = result.stdout:match('^NVIM v([^\n]+)') or 'unknown'
print('✅ Neovim upgraded from ' .. old_version .. ' to ' .. new_version)
