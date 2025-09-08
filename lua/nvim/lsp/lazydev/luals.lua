local Workspace = require('nvim.lsp.lazydev.workspace')

---@param client? vim.lsp.Client
local function assert_is_luals(client)
  assert(client and client.name == 'luals', 'lazydev: Not a luals client??')
end

local M = {
  ---@type table<number,number>
  attached = {},

  ---@param params lsp.ConfigurationParams
  on_workspace_configuration = function(err, params, ctx, cfg)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    assert_is_luals(client)
    if not client or not params.items or #params.items == 0 then
      return {}
    end

    -- fallback scope
    if #(client.workspace_folders or {}) > 0 and not params.items[1].scopeUri then
      return {}
    end

    local response = {}
    for _, item in ipairs(params.items) do
      if item.section then
        local settings = client.settings
        if item.section == 'Lua' then
          local ws = item.scopeUri and Workspace.get(client, vim.uri_to_fname(item.scopeUri))
            or Workspace.single(client)
          if ws:enabled() then
            settings = ws.settings
          end
        end

        local keys = vim.split(item.section, '.', { plain = true }) --- @type string[]
        local value = vim.tbl_get(settings or {}, unpack(keys))
        -- For empty sections with no explicit '' key, return settings as is
        if value == nil and item.section == '' then
          value = settings
        end
        if value == nil then
          value = vim.NIL
        end
        table.insert(response, value)
      end
    end
    return response
  end,

  ---@param client vim.lsp.Client
  update = function(client)
    assert_is_luals(client)
    client:notify('workspace/didChangeConfiguration', { settings = { Lua = {} } })
  end,
}

---@param client vim.lsp.Client
M.attach = function(client)
  if M.attached[client.id] then
    return
  end

  assert_is_luals(client)
  M.attached[client.id] = client.id

  -- lspconfig uses the same empty table for all clients.
  -- We need to make sure that each client has its own handlers table.
  client.handlers = vim.tbl_extend('force', {}, client.handlers or {})
  client.handlers['workspace/configuration'] = M.on_workspace_configuration
end

return M
