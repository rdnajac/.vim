--- Common settings for nvim config related pickers
--- @module "snacks"

--- Some picker sources (like keymaps and autocmds) have a default
--- confirm action that isn't always as useful as just jumping to the
--- file. This function can be used to overrides that action.
--- @param p snacks.Picker
--- @param item snacks.picker.Item
local function config_confirm(p, item)
  local file = item and item.file
  if not file or file == '' then
    Snacks.notify.warn('No file associated with this item')
    return
  end
  p:action('jump', file) -- TODO: make jump work for vimscript items
end

---@type snacks.picker.Config
return {
  confirm = config_confirm,
}
