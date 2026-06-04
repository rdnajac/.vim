local M = {}

---@param item snacks.picker.Item
---@return string?
local function item_ft(item)
  if item.filetype and item.filetype ~= '' then
    return item.filetype
  end
  if item.buf and vim.api.nvim_buf_is_valid(item.buf) then
    local ft = vim.bo[item.buf].filetype
    if ft ~= '' then
      return ft
    end
  end
  if item.file then
    return vim.filetype.match({ filename = item.file }) or vim.fn.fnamemodify(item.file, ':e')
  end
end

---@param picker snacks.Picker
---@param fts string[]?
local function set_filter(picker, fts)
  picker.opts.ft = fts and #fts > 0 and fts or nil
  if picker.opts.source ~= 'buffers' then
    return
  end

  local filter_fn = picker.opts.ft
      and function(item)
        local ft = item_ft(item)
        return ft and vim.tbl_contains(picker.opts.ft, ft) or false
      end
    or nil

  picker.opts.filter = filter_fn and { filter = filter_fn } or nil

  if picker.input and picker.input.filter then
    picker.input.filter:init(picker.opts)
  end
end

---@param input string
---@return string[]
local function parse(input)
  return vim
    .iter(vim.split(input, ',', { trimempty = true }))
    :map(vim.trim)
    :filter(function(ft) return ft ~= '' end)
    :totable()
end

local function refresh(picker)
  picker:action('set_title')
  picker:refresh()
end

function M.clear(picker)
  set_filter(picker, nil)
  refresh(picker)
end

function M.filter(picker)
  vim.ui.input({
    prompt = 'Filter by filetype (comma separated for multiple)',
  }, function(input)
    if input then
      set_filter(picker, parse(input))
      refresh(picker)
    end
  end)
end

return M
