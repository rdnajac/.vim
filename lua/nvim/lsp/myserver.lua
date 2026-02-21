-- ~/.vim/lua/nvim/util/git/fs/server.lua
local M = {}

local capabilities = {
  codeActionProvider = true,
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

  if ft ~= 'lua' then
    return callback(nil, {})
  end

  local line_num = params.range.start.line + 1
  local line = vim.api.nvim_buf_get_lines(bufnr, line_num - 1, line_num, false)[1]
  if not line then
    return callback(nil, {})
  end

  local actions = {}

  -- Coerce actions
  local coerce_rules = {
    { name = 'Toggle function form', fn = 'form' },
    { name = 'Toggle local/module scope', fn = 'scope' },
    { name = 'Toggle vim variable', fn = 'vim' },
    { name = 'Form then scope', fn = 'formscope' },
    { name = 'Scope then form', fn = 'scopeform' },
    { name = 'Copy vim var to clipboard', fn = 'vimcopy' },
  }

  for _, rule in ipairs(coerce_rules) do
    table.insert(actions, {
      title = rule.name,
      kind = vim.lsp.protocol.CodeActionKind.RefactorRewrite,
      command = {
        title = rule.name,
        command = 'lua.action.' .. rule.fn,
        arguments = { bufnr, line_num },
      },
    })
  end

  -- Yankmod actions
  local yankmod_actions = {
    { name = 'Yank require()', fn = 'require' },
    { name = 'Yank require().func()', fn = 'require_func' },
  }

  for _, action in ipairs(yankmod_actions) do
    table.insert(actions, {
      title = action.name,
      kind = vim.lsp.protocol.CodeActionKind.Empty,
      command = {
        title = action.name,
        command = 'lua.action.' .. action.fn,
        arguments = { bufnr },
      },
    })
  end

  callback(nil, actions)
end

-- TODO: code action to insert ---@param for each param and a ---@return

-- Execute command handler
methods['workspace/executeCommand'] = function(params, callback)
  local cmd = params.command
  local args = params.arguments or {}

  if cmd:match('^lua%.action%.') then
    local fn_name = cmd:match('^lua%.action%.(.+)$')
    local bufnr = args[1]
    local line_num = args[2]

    if M[fn_name] then
      vim.api.nvim_buf_call(bufnr, function()
        if line_num then
          vim.api.nvim_win_set_cursor(0, { line_num, 0 })
        end
        M[fn_name]()
      end)
    end
  end

  callback(nil, nil)
end

local function create_client(disp)
  local closing, request_id = false, 0

  return {
    request = function(_, method, params, callback)
      local method_impl = methods[method]
      if method_impl then
        method_impl(params, callback)
      end
      request_id = request_id + 1
      return true, request_id
    end,
    notify = function(_, method, _)
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
  name = 'nv',
  root_dir = vim.env.HOME or vim.uv.cwd(),
}, { attach = false }))

return M
