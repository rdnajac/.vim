#!/usr/bin/env -S nvim -l
-- Update `neovim` nightly build for ARM64 on macOS.
-- TODO: luals doesn't know what to do with require('nvim')

local URL = 'https://github.com/neovim/neovim/releases/download/nightly/nvim-macos-arm64.tar.gz'
local TARBALL = vim.fs.joinpath('/tmp', URL:match('^.+/(.+)$'))
local DATA_HOME = vim.env.XDG_DATA_HOME or vim.fs.joinpath(vim.env.HOME, '.local', 'share')
local INSTALL_DIR = vim.fs.joinpath(DATA_HOME, 'nvim')
local BIN_DIR = vim.fs.joinpath(vim.env.HOME, '.local', 'bin')

-- Create necessary directories if they don't exist
-- TODO: use `uv.fs_mkdir()`?
vim.fn.mkdir(INSTALL_DIR, 'p')
vim.fn.mkdir(BIN_DIR, 'p')

-- Capture output of a Vim command
local result = vim.api.nvim_exec2('version', { output = true }).output

-- Now you can split into a Lua table by lines
local version = result
  :match('([^\n]+)') -- Get the first line
  :match('NVIM v(.+)') -- Extract version number

print('Upgrading neovim from ' .. (version or 'unknown') .. ' to nightly...')

-- download tarball
local wget = require('nvim.util.wget')

wget(URL, {
  outpath = TARBALL,
  create_dirs = true,
  force = true,
})

vim.system({ "xattr", "-c", TARBALL }):wait()
vim.system({ "rm", "-rfv", INSTALL_DIR .. "/runtime" }):wait()
vim.system({ "tar", "-xzf", TARBALL, "-C", INSTALL_DIR, "--strip-components=1" }):wait()
vim.system({ "ln", "-sfv", INSTALL_DIR .. "/bin/nvim", BIN_DIR .. "/nvim" }):wait()
vim.system({ "rm", "-fv", TARBALL }):wait()

local result = vim.system({ BIN_DIR .. "/nvim", "--version" }, { text = true }):wait()

if result.code ~= 0 then
  print("❌ Error running nvim --version: " .. (result.stderr ~= "" and result.stderr or "unknown error"))
else
  local first_line = result.stdout:match("([^\n]+)")
  print("✅ Neovim upgraded to " .. (first_line or "unknown version"))
end
