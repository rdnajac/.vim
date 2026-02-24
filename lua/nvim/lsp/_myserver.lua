local function yankmod(format) nv.yank(transform.formats[format](nv.modname(vim.fn.expand('%:p')))) end

---@param line string
---@param rule { regex: string, transform: string }

local function transform(line, rule) return line:gsub(rule.regex, rule.transform) end
local function apply(rules)
  local line = vim.api.nvim_get_current_line()
  for _, rule in ipairs(rules) do
    local new_line = transform_line(line, rule)
    if new_line and new_line ~= line then
      return new_line
    end
  end
end

local methods = {}

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
