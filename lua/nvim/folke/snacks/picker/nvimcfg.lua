--- Common settings for nvim config related pickers
--- @module "snacks"

--- Some picker sources (like keymaps and autocmds) have a default
--- confirm action that isn't always as useful as just jumping to the
--- file. This function can be used to overrides that action.
--- @param p snacks.Picker
--- @param item snacks.picker.Item
local function config_confirm(p, item)
  if not nv.fn.is_nonempty_string(item.file) then
    local sid = item.item.sid
    local info = vim.fn.getscriptinfo({ sid = sid })
    item.file = info and info[1] and info[1].name
    item.pos = { item.item.lnum, 0 }
  end
  p:action({ 'jump' })
end

---@type snacks.picker.Config
return {
  confirm = config_confirm,
}
