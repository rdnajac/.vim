M.config = setmetatable({}, {
  __index = function(_, k)
    config[k] = config[k] or {}
    return config[k]
  end,
  __newindex = function(_, k, v)
    config[k] = v
  end,
})

local is_dict_like = function(v) -- has string and number keys
  return type(v) == 'table' and (vim.tbl_isempty(v) or not svim.islist(v))
end
local is_dict = function(v) -- has only string keys
  return type(v) == 'table' and (vim.tbl_isempty(v) or not v[1])
end

--- Merges the values similar to vim.tbl_deep_extend with the **force** behavior,
--- but the values can be any type
---@generic T
---@param ... T
---@return T
function M.merge(...)
  local ret = select(1, ...)
  for i = 2, select('#', ...) do
    local value = select(i, ...)
    if is_dict_like(ret) and is_dict(value) then
      for k, v in pairs(value) do
        ret[k] = M.merge(ret[k], v)
      end
    elseif value ~= nil then
      ret = value
    end
  end
  return ret
end

---@generic T: table
---@param snack string
---@param defaults T
---@param ... T[]
---@return T
function M.get(snack, defaults, ...)
  local merge, todo = {}, { defaults, config[snack] or {}, ... }
  for i = 1, select('#', ...) + 2 do
    local v = todo[i] --[[@as snacks.Config.base]]
    if type(v) == 'table' then
      table.insert(merge, vim.deepcopy(v))
    end
  end
  local ret = M.merge(unpack(merge))
  if type(ret.config) == 'function' then
    ret.config(ret, defaults)
  end
  return ret
end

---@param opts snacks.Config?
function M.setup(opts)
  -- enable all by default when config is passed
  opts = opts or {}
  for k in pairs(opts) do
    opts[k].enabled = opts[k].enabled == nil or opts[k].enabled
  end
  config = vim.tbl_deep_extend('force', config, opts or {})

  local events = {
    BufReadPre = { 'bigfile', 'image' },
    BufReadPost = { 'quickfile', 'indent' },
    BufEnter = { 'explorer' },
    LspAttach = { 'words' },
    UIEnter = { 'dashboard', 'scroll', 'input', 'scope', 'picker' },
  }

  ---@param event string
  ---@param ev? vim.api.keyset.create_autocmd.callback_args
  local function load(event, ev)
    local todo = events[event] or {}
    events[event] = nil
    for _, snack in ipairs(todo) do
      if M.config[snack] and M.config[snack].enabled then
        if M[snack].setup then
          M[snack].setup(ev)
        elseif M[snack].enable then
          M[snack].enable()
        end
      end
    end
  end

  if vim.v.vim_did_enter == 1 then
    M.did_setup_after_vim_enter = true
    load('UIEnter')
  end

  local group = vim.api.nvim_create_augroup('snacks_load?', {})
  vim.api.nvim_create_autocmd(vim.tbl_keys(events), {
    group = group,
    once = true,
    nested = true,
    callback = function(ev)
      load(ev.event, ev)
    end,
  })
end

return M
