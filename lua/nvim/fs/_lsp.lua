-- vim.pack._lsp
local fs = vim.fs

local M = {}

local capabilities = {
  codeActionProvider = true,
  -- documentSymbolProvider = true,
  executeCommandProvider = { commands = { 'delete', 'rename' } },
  hoverProvider = true,
}

---@type table<string, function>
local methods = {
  initialize = function(_, callback)
    return callback(nil, { capabilities = capabilities })
  end,
  shutdown = function(_, callback)
    return callback(nil, nil)
  end,
}

local get_path = function(lineno)
  lineno = lineno and tonumber(lineno) or '.'
  return fs.normalize(fs.abspath(fs.joinpath(vim.api.nvim_buf_get_name(0), vim.fn.getline(lineno))))
end

---@alias dir.lsp.Position { line: integer, character: integer }
---@alias dir.lsp.Range { start: dir.lsp.Position, end: dir.lsp.Position }
---@alias dir.lsp.CodeActionContext { diagnostics: table, only: table?, triggerKind: integer? }
---@alias dir.lsp.Symbol { name: string, kind: number, range: dir.lsp.Range, selectionRange: dir.lsp.Range }

---@param params { textDocument: { uri: string }, range: dir.lsp.Range, context: dir.lsp.CodeActionContext }
---@param callback function
methods['textDocument/codeAction'] = function(params, callback)
  -- local bufnr = vim.uri_to_bufnr(params.textDocument.uri)
  local empty_kind = vim.lsp.protocol.CodeActionKind.Empty
  local only = params.context.only or { empty_kind }
  if not vim.tbl_contains(only, empty_kind) then
    return callback(nil, {})
  end

  local path = get_path(params.range.start.line + 1)

  local function new_action(title, command)
    return {
      title = ('%s `%s`'):format(title, fs.basename(path)),
      command = { title = title, command = command, arguments = { path } },
    }
  end

  local res = {
    new_action('Delete', 'delete'),
    new_action('Rename', 'rename'),
  }
  callback(nil, res)
end

local refresh = function()
  require('nvim.dir')._reload()
  nv.fs.thumbnails.render(0)
end

local commands = {
  delete = function(path)
    local name = vim.fn.fnamemodify(path, ':~')
    local res = vim.fn.input(('Delete "%s"? [y/N] '):format(name))
    vim.cmd('echon ""')
    if res:lower() ~= 'y' then
      return
    end
    local _action = vim.endswith(path, '/') and 'rmdir' or 'unlink'
    vim.uv['fs_' .. _action](path, function(err)
      if err then
        Snacks.notify.error('Failed to delete: ' .. err)
      else
        Snacks.notify.warn('Deleted: ' .. name)
        vim.schedule(function()
          Snacks.bufdelete({ file = path, wipe = true })
          refresh()
        end)
      end
    end)
  end,
  rename = function(path)
    Snacks.rename.rename_file({ from = path, on_rename = refresh })
  end,
}

---@param params { command: string, arguments: table }
---@param callback function
methods['workspace/executeCommand'] = vim.schedule_wrap(function(params, callback)
  local path = unpack(params.arguments)
  local ok, err = pcall(commands[params.command], path)
  if not ok then
    return callback({ code = 1, message = err }, {})
  end
  callback(nil, {})
end)

---@param params { textDocument: { uri: string }, position: dir.lsp.Position }
---@param callback function
methods['textDocument/hover'] = function(params, callback)
  local path = get_path()
  local ok, lines = pcall(vim.fn.readfile, path)
  if not ok or not lines then
    return
  end
  local ft = vim.filetype.match({ filename = path }) or vim.fn.fnamemodify(path, ':e')
  local markdown = ('```%s\n%s\n```'):format(ft, table.concat(lines, '\n'))
  local res = { contents = { kind = vim.lsp.protocol.MarkupKind.Markdown, value = markdown } }
  callback(nil, res)
end

--- @return vim.lsp.rpc.Client
function M.cmd(dispatchers)
  local closing = false
  local request_id = 0
  local server = { ---@type vim.lsp.rpc.Client
    is_closing = function()
      return closing
    end,
    terminate = function()
      closing = true
    end,
    notify = function(method, params)
      if method == 'exit' then
        dispatchers.on_exit(0, 15)
      end
      -- return false
    end,
    -- the important func...
    request = function(method, params, callback)
      local method_impl = methods[method]
      if method_impl then
        method_impl(params, callback)
      end
      request_id = request_id + 1
      return true, request_id
    end,
  }
  return server
end

return M
