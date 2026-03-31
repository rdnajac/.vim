local api, fn, lsp = vim.api, vim.fn, vim.lsp

-- NOTE: blink automatically adds some capabilities
-- `$PACKDIR/blink.cmp/lua/blink/cmp/sources/lib/init.lua`
--- `:h vim.lsp.protocol.make_client_capabilities()` for defaults

local M = {}

---@param buf? number
M.attached = function(buf) return lsp.get_clients({ bufnr = buf or api.nvim_get_current_buf() }) end

---@return string status icons of all attached clients
M.status = function() return vim.iter(M.attached()):map(require('nvim.lsp.status')):join(' ') end

vim.schedule(function()
  local lsp_config_dir = fn.stdpath('config') .. '/after/lsp'
  M.servers = vim
    .iter(fn.globpath(lsp_config_dir, '*', false, true))
    :map(function(path) return vim.fn.fnamemodify(path, ':t:r') end)
    :totable()

  -- folke/lazydev.nvim
  Plug(require('nvim.lsp.lazydev'))

  -- enable servers found in the after directory
  lsp.enable(M.servers)

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

api.nvim_create_autocmd('LspProgress', {
  callback = function(ev)
    local id, value = ev.data.client_id, ev.data.params.value
    local is_end = value.kind == 'end'
    local title = ([[[%s] %s %s]]):format(
      vim.lsp.get_client_by_id(id).name or 'LSP',
      is_end and '' or Snacks.util.spinner(),
      value.title -- append the original title
    )

    api.nvim_echo({ { value.message or '100% done' } }, false, {
      id = 'lsp:' .. id,
      kind = 'progress',
      source = 'nv.lsp',
      title = title,
      status = is_end and 'success' or 'running',
      percent = value.percentage,
      verbose = false,
    })

    vim.cmd.redrawstatus()
  end,
})

return M
