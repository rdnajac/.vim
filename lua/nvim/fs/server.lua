-- $VIMRUNTIME/lua/vim/pack/_lsp.lua
local fs = vim.fs

local M = {}

local capabilities = {
  codeActionProvider = true,
  documentSymbolProvider = true,
  executeCommandProvider = { commands = { 'delete', 'rename' } },
  hoverProvider = true,
}
---@type table<string, function>
local methods = {}

---@param callback function
function methods.initialize(_, callback) return callback(nil, { capabilities = capabilities }) end

---@param callback function
function methods.shutdown(_, callback) return callback(nil, nil) end

---@alias dir.lsp.Position { line: integer, character: integer }
---@alias dir.lsp.Range { start: dir.lsp.Position, end: dir.lsp.Position }
---@alias dir.lsp.CodeActionContext { diagnostics: table, only: table?, triggerKind: integer? }
---@alias dir.lsp.Symbol { name: string, kind: number, range: dir.lsp.Range, selectionRange: dir.lsp.Range }

local get_path = function(lineno)
  lineno = lineno and tonumber(lineno) or '.'
  return fs.normalize(fs.abspath(fs.joinpath(vim.api.nvim_buf_get_name(0), vim.fn.getline(lineno))))
end

---@param params { textDocument: { uri: string }, range: dir.lsp.Range, context: dir.lsp.CodeActionContext }
---@param callback function
methods['textDocument/codeAction'] = function(params, callback)
  local bufnr = vim.uri_to_bufnr(params.textDocument.uri)
  local empty_kind = vim.lsp.protocol.CodeActionKind.Empty
  local only = params.context.only or { empty_kind }
  if not vim.tbl_contains(only, empty_kind) then
    return callback(nil, {})
  end

  -- unconcealed dirvish lines are already absolute paths
  local abspath = get_path(params.range.start.line + 1)

  local function new_action(title, command)
    return {
      title = ('%s `%s`'):format(title, fs.basename(abspath)),
      command = { title = title, command = command, arguments = { abspath } },
    }
  end

  local res = {
    new_action('Delete', 'delete'),
    new_action('Rename', 'rename'),
  }
  callback(nil, res)
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
          vim.cmd.Dirvish() -- refresh
        end)
      end
    end)
  end,

  rename = function(path)
    Snacks.rename.rename_file({
      from = path,
      on_rename = function()
        vim.cmd.Dirvish() -- refresh
      end,
    })
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

---@param params { textDocument: { uri: string }, position: dirvish.lsp.Position }
---@param callback function
methods['textDocument/hover'] = function(params, callback)
  local bufnr = vim.uri_to_bufnr(params.textDocument.uri)
  if not bufnr then
    return
  end

  -- TODO: id is directory....
  local cmd = { 'ls', '-ldhG', get_path() }

  ---@param sys_out vim.SystemCompleted
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

  function res.is_closing() return closing end
  function res.terminate() closing = true end
  function res.notify(method, _)
    if method == 'exit' then
      disp.on_exit(0, 15)
    end
    return false
  end

  function res.request(method, params, callback)
    local method_impl = methods[method]
    if method_impl ~= nil then
      method_impl(params, callback)
    end
    request_id = request_id + 1
    return true, request_id
  end

  return res
end

M.client_id = assert(
  vim.lsp.start(
    { cmd = cmd, name = 'nvimdir', root_dir = vim.env.HOME or vim.uv.cwd() },
    { attach = false }
  )
)

return M
