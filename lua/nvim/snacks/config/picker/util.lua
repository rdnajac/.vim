local M = {}

---@module "snacks"
-- see: `Snacks.picker.picker_actions()`

---@param picker snacks.Picker
local toggle = function(picker)
  local cwd = picker:cwd()
  local alt = picker.opts.source == 'files' and 'grep' or 'files'
  picker:close()
  if alt == 'files' then
    Snacks.picker.files({ cwd = cwd })
  else
    Snacks.picker.grep({ cwd = cwd })
  end
end

M.opts_extend = {
  actions = {
    toggle = function(self)
      toggle(self)
    end,
  },
  config = function(opts)
    local icon_map = {
      grep = '󰱽',
      files = '',
    }
    local icon = icon_map[opts.finder]
    local name = opts.finder:sub(1, 1):upper() .. opts.finder:sub(2)
    opts.title = string.format('%s %s [ %s ]', icon, name, vim.fn.fnamemodify(opts.cwd, ':~'))
    -- TODO: filter out copilot dirs in workspace and take the root
    opts.cwd = opts.cwd or (vim.lsp.buf.list_workspace_folders()[1] or vim.fn.getcwd())
    return opts
  end,
  win = {
    input = {
      keys = {
        ['`'] = { 'toggle', mode = { 'i', 'n' } },
      },
    },
  },
}

-- TODO: test this against current implementation
-- https://github.com/folke/snacks.nvim/discussions/2003#discussioncomment-13653042
---@type table<string, snacks.picker.Config>
local reopen_state = {}

---@param picker snacks.Picker
---@param source string
---@param opts? snacks.picker.Config
local reopen_picker = function(picker, source, opts)
  local on_close = picker.opts.on_close
  picker.opts.on_close = function(picker) ---@diagnostic disable-line
    if not picker.skip_reset then
      reopen_state = {}
    end
    if type(on_close) == 'function' then
      on_close(picker)
    end
  end
  local from_source = picker.opts.source
  if from_source then
    reopen_state[from_source] = picker.opts
    reopen_state[from_source].pattern = picker:filter().pattern
    reopen_state[from_source].search = picker:filter().search
  end
  picker.skip_reset = true
  picker:close()
  Snacks.picker.pick(source, vim.tbl_extend('force', reopen_state[source] or {}, opts or {}))
end

return M
