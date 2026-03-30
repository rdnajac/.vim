local api, fn, lsp = vim.api, vim.fn, vim.lsp

-- NOTE: blink automatically adds some capabilities
-- `$PACKDIR/blink.cmp/lua/blink/cmp/sources/lib/init.lua`
--- `:h vim.lsp.protocol.make_client_capabilities()` for defaults

local M = {}

---@param buf? number
M.attached = function(buf) return lsp.get_clients({ bufnr = buf or api.nvim_get_current_buf() }) end

---@return string status icons of all attached clients
M.status = function() return vim.iter(M.attached()):map(require('nvim.lsp.status')):join(' ') end

---@return string[] servers found in the after directory
M.servers = function()
  return vim.tbl_map(
    function(path) return path:match('^.+/(.+)$'):sub(1, -5) end,
    fn.globpath(vim.fs.joinpath(fn.stdpath('config'), 'after', 'lsp'), '*', false, true)
  )
end

vim.schedule(function()
  -- enable servers found in the after directory
  lsp.enable(M.servers())

  -- folke/lazydev.nvim
  Plug(require('nvim.lsp.lazydev'))

  M.progress = require('nvim.lsp.progress')
  api.nvim_create_autocmd('LspProgress', { callback = nv.lsp.progress.callback })

  vim.cmd([[
    nnoremap glc <Cmd>lua Snacks.picker.lsp_config()<CR>
    nnoremap gls <Cmd>lua Snacks.picker.lsp_symbols()<CR>
    nnoremap glS <Cmd>lua Snacks.picker.lsp_workspace_symbols()<CR>
    nnoremap gli <Cmd>lua Snacks.picker.lsp_incoming_calls()<CR>
    nnoremap glo <Cmd>lua Snacks.picker.lsp_outgoing_calls()<CR>
    nnoremap gld <Cmd>lua Snacks.picker.lsp_definitions()<CR>
    nnoremap glD <Cmd>lua Snacks.picker.lsp_declarations()<CR>
    nnoremap glR <Cmd>lua Snacks.picker.lsp_references()<CR>
    nnoremap glI <Cmd>lua Snacks.picker.lsp_implementations()<CR>
    nnoremap glT <Cmd>lua Snacks.picker.lsp_type_definitions()<CR>
    nnoremap glW <Cmd>=vim.lsp.buf.list_workspace_folders()<CR>
  ]])
end)

return M
