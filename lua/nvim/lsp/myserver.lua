-- ~/.local/share/nvim/share/nvim/runtime/lua/vim/pack/_lsp.lua
-- ~/.vim/lua/nvim/util/git/fs/server.lua
local M = {}

local capabilities = {
  codeActionProvider = true,
  executeCommandProvider = {
    commands = { 'myserver._test' },
  },
}

local methods = {
  initialize = function(_, callback)
    -- TODO:
    return callback(nil, { capabilities = capabilities })
  end,
  shutdown = function(_, callback) return callback(nil, nil) end,
}

--- @param params { textDocument: { uri: string }, range: lsp.Range, context: lsp.CodeActionContext }
--- @param callback function
methods['textDocument/codeAction'] = function(params, callback)
  local bufnr = vim.uri_to_bufnr(params.textDocument.uri)
  local ft = vim.bo[bufnr].filetype
  local fname = vim.api.nvim_buf_get_name(bufnr)

  callback(nil, {
    {
      title = 'Print file info',
      kind = vim.lsp.protocol.CodeActionKind.Empty,
      command = {
        title = 'Print file info',
        command = 'myserver._test',
        arguments = { fname, ft },
      },
    },
  })
end

-- TODO: code action to insert ---@param for each param and a ---@return
methods['workspace/executeCommand'] = function(params, callback)
  local cmd = params.command
  local args = params.arguments or {}

  if cmd == 'myserver._test' then
    vim.notify(('file: %s\nft: %s'):format(args[1], args[2]))
  end

  callback(nil, nil)
end

local function create_client(disp)
  local closing, request_id = false, 0

  return {
    request = function(method, params, callback)
      local method_impl = methods[method]
      if method_impl then
        method_impl(params, callback)
      end
      request_id = request_id + 1
      return true, request_id
    end,
    notify = function(method, _)
      if method == 'exit' then
        disp.on_exit(0, 15)
      end
      return false
    end,
    is_closing = function() return closing end,
    terminate = function() closing = true end,
  }
end

M.client_id = assert(vim.lsp.start({
  cmd = create_client,
  name = 'myserver',
  root_dir = vim.g.stdpath.config,
}, { attach = false }))

return M
