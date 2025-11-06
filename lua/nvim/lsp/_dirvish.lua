-- ~/.local/share/nvim/share/nvim/runtime/lua/vim/pack/_lsp.lua
local M = {}

local capabilities = {
  codeActionProvider = true,
  documentSymbolProvider = true,
  executeCommandProvider = { commands = { 'delete', 'rename' } },
  hoverProvider = true,
}
--- @type table<string,function>
local methods = {}

--- @param callback function
function methods.initialize(_, callback)
  return callback(nil, { capabilities = capabilities })
end

--- @param callback function
function methods.shutdown(_, callback)
  return callback(nil, nil)
end

local get_dirvish_bufnr = function(uri)
  local bufnr = vim.uri_to_bufnr(uri)
  if vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].filetype == 'dirvish' then
    return bufnr
  end
  return nil
end

--- @return { path: string?, lnum: integer }
local get_file_at_lnum = function(bufnr, lnum)
  local lines = vim.api.nvim_buf_get_lines(bufnr, lnum - 1, lnum, false)
  local path = nil
  if #lines > 0 and vim.trim(lines[1]) ~= '' then
    path = lines[1]
  end
  return { path = path, lnum = lnum }
end

--- @alias dirvish.lsp.Position { line: integer, character: integer }
--- @alias dirvish.lsp.Range { start: dirvish.lsp.Position, end: dirvish.lsp.Position }
--- @alias dirvish.lsp.CodeActionContext { diagnostics: table, only: table?, triggerKind: integer? }
--- @alias dirvish.lsp.Symbol { name: string, kind: number, range: dirvish.lsp.Range, selectionRange: dirvish.lsp.Range }

--- @param params { textDocument: { uri: string } }
--- @param callback function
methods['textDocument/documentSymbol'] = function(params, callback)
  local bufnr = get_dirvish_bufnr(params.textDocument.uri)
  if not bufnr then
    return callback(nil, {})
  end

  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local symbols = {}

  for i, line in ipairs(lines) do
    local trimmed = vim.trim(line)
    if trimmed ~= '' then
      local name = vim.fn.fnamemodify(trimmed, ':t')
      local kind = trimmed:match('/$') and vim.lsp.protocol.SymbolKind.Namespace
        or vim.lsp.protocol.SymbolKind.File
      local range = {
        start = { line = i - 1, character = 0 },
        ['end'] = { line = i - 1, character = 0 },
      }
      table.insert(symbols, { name = name, kind = kind, range = range, selectionRange = range })
    end
  end

  callback(nil, symbols)
end

--- @param params { textDocument: { uri: string }, range: dirvish.lsp.Range, context: dirvish.lsp.CodeActionContext }
--- @param callback function
methods['textDocument/codeAction'] = function(params, callback)
  local bufnr = get_dirvish_bufnr(params.textDocument.uri)
  if not bufnr or vim.bo[bufnr].filetype ~= 'dirvish' then
    return callback(nil, {})
  end

  local empty_kind = vim.lsp.protocol.CodeActionKind.Empty
  local only = params.context.only or { empty_kind }
  if not vim.tbl_contains(only, empty_kind) then
    return callback(nil, {})
  end

  local file_data = get_file_at_lnum(bufnr, params.range.start.line + 1)
  if not file_data.path then
    return callback(nil, {})
  end

  local function new_action(title, command)
    local filename = vim.fn.fnamemodify(file_data.path, ':t')
    return {
      title = ('%s `%s`'):format(title, filename),
      command = { title = title, command = command, arguments = { bufnr, file_data } },
    }
  end

  local res = {
    new_action('Delete', 'delete'),
    new_action('Rename', 'rename'),
  }
  callback(nil, res)
end

local commands = {
  delete = function(file_data)
    vim.uv.fs_unlink(file_data.path, function(err)
      if err then
        Snacks.notify.error('Failed to delete: ' .. err)
      else
        vim.schedule(function()
          Snacks.bufdelete({ file = file_data.path, wipe = true })
          vim.cmd.Dirvish()
        end)
      end
    end)
  end,

  rename = function(file_data)
    Snacks.rename.rename_file({
      from = file_data.path,
      on_rename = function()
        vim.cmd.Dirvish()
      end,
    })
  end,
}

--- @param params { command: string, arguments: table }
--- @param callback function
methods['workspace/executeCommand'] = vim.schedule_wrap(function(params, callback)
  local _, file_data = unpack(params.arguments)
  local ok, err = pcall(commands[params.command], file_data)
  if not ok then
    return callback({ code = 1, message = err }, {})
  end
  callback(nil, {})
end)

--- @param params { textDocument: { uri: string }, position: dirvish.lsp.Position }
--- @param callback function
methods['textDocument/hover'] = function(params, callback)
  local bufnr = get_dirvish_bufnr(params.textDocument.uri)
  if not bufnr then
    return
  end

  local file_data = get_file_at_lnum(bufnr, params.position.line + 1)
  if not file_data.path then
    return
  end

  local path = file_data.path
  local cmd = { 'ls', '-ldhG', path }

  --- @param sys_out vim.SystemCompleted
  local on_exit = function(sys_out)
    if sys_out.code ~= 0 then
      return
    end
    local output = vim.trim(sys_out.stdout)
    local markdown = '```\n' .. output .. '\n```'
    local res = { contents = { kind = vim.lsp.protocol.MarkupKind.Markdown, value = markdown } }
    callback(nil, res)
  end

  vim.system(cmd, {}, vim.schedule_wrap(on_exit))
end

local cmd = function(disp)
  local res, closing, request_id = {}, false, 0

  function res.request(method, params, callback)
    local method_impl = methods[method]
    if method_impl ~= nil then
      method_impl(params, callback)
    end
    request_id = request_id + 1
    return true, request_id
  end

  function res.notify(method, _)
    if method == 'exit' then
      disp.on_exit(0, 15)
    end
    return false
  end

  function res.is_closing()
    return closing
  end

  function res.terminate()
    closing = true
  end

  return res
end

M.client_id = assert(
  vim.lsp.start({ cmd = cmd, name = 'dirvish', root_dir = vim.uv.cwd() }, { attach = false })
)

M.status = function()
  return vim.lsp.client_is_active(M.client_id) and nv.icons.lsp.print
end

return M
