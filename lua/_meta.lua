--- @meta
error('this file should not be required directly')

---@class vim.api.create_autocmd.callback.args
---@field id number
---@field event string
---@field group number?
---@field match string
---@field buf number
---@field file string
---@field data any

---@class vim.api.keyset.create_autocmd.opts: vim.api.keyset.create_autocmd
---@field callback? fun(ev:vim.api.create_autocmd.callback.args):boolean?

--- @param event any (string|array) Event(s) that will trigger the handler
--- @param event vim.api.keyset.events|vim.api.keyset.events[]
--- @param opts vim.api.keyset.create_autocmd.opts
--- @return integer
-- function vim.api.nvim_create_autocmd(event, opts) end

-- these should be generated automatically...
nv.lsp = require('nvim.util.lsp')
nv.status = require('nvim.util.status')

---@class GitResult
---@field exit_status integer Exit code of Git command
---@field stdout string[] Lines from stdout
---@field stderr string[] Lines from stderr

---@param args string[] Git command arguments (without "git" prefix)
---@param dir? string Git directory path
---@param cb? fun(result:GitResult) Optional callback for async execution
---@return GitResult
vim.fn.FugitiveExecute = function(args, dir, cb) end

---@param bufnr? integer|string|table Buffer number, path string, or table with git_dir key. Defaults to current buffer if not provided.
---@return string
vim.fn.FugitiveGitDir = function(bufnr) end
