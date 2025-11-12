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

--- @param event vim.api.keyset.events|vim.api.keyset.events[]
--- @param opts vim.api.keyset.create_autocmd.opts
--- @return integer
-- function vim.api.nvim_create_autocmd(event, opts) end

---@param fn fun(args: vim.api.keyset.create_autocmd.callback_args): boolean?
