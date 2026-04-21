---@meta

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
