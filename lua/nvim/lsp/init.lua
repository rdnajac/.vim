--- see `:h vim.lsp.protocol.make_client_capabilities()` for defaults
--- NOTE: blink.cmp will automatically add additional capabilities
--- `$PACKDIR/blink.cmp/lua/blink/cmp/sources/lib/init.lua`

local M = {}

vim.schedule(function()
  local lsp_config_dir = vim.fn.stdpath('config') .. '/after/lsp'
  M.servers = vim
    .iter(vim.fn.globpath(lsp_config_dir, '*', false, true))
    :map(function(path) return vim.fn.fnamemodify(path, ':t:r') end)
    :totable()

  -- enable servers found in the after directory
  vim.lsp.enable(M.servers)

  -- folke/lazydev.nvim
  Plug(require('nvim.lsp.lazydev'))

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

vim.api.nvim_create_autocmd('LspProgress', 
{
  callback = function(ev)
    local id, params = ev.data.client_id, ev.data.params
    local value = params.value
    local is_end = value.kind == 'end'
    local title = ([[[%s] %s %s]]):format(
      vim.lsp.get_client_by_id(id).name or 'LSP',
      is_end and '' or Snacks.util.spinner(),
      value.title -- append the original title
    )

    vim.api.nvim_echo({ { value.message or '100% done' } }, false, {
      id = 'lsp.' .. params.token,
      kind = 'progress',
      source = 'nv.lsp',
      title = title,
      status = is_end and 'success' or 'running',
      percent = value.percentage,
      verbose = false,
    })

    vim.cmd.redrawstatus()
  end,
}
)

---@param bufnr? integer
---@return string
M.status = function(bufnr)
  return vim
    .iter(vim.lsp.get_clients({ bufnr = vim._resolve_bufnr(bufnr) }))
    ---@param client vim.lsp.Client
    :map(function(client)
      -- TODO: busy status
      local icons = require('nvim.ui.icons')
      if client.name ~= 'copilot' then
        return icons.copilot .. ' '
      end
      local status = client:is_stopped() and 'stopped' or 'active'
      return icons.lsp_status[status] .. ' '
    end)
    :join(' ')
end


return M
