-- apply icons to special filesystem buffers like netrw and dirvish
local api = vim.api
local fs = vim.fs
local aug = api.nvim_create_augroup('fs-icons', {})
local ns = api.nvim_create_namespace('fs-icons')
-- `~/.local/share/nvim/cache/fs-icons.json`
local cache_path = vim.fn.stdpath('cache') .. '/fs-icons.json'
local ok, cache = pcall(nv.file.read_json, cache_path)
_G.icon_cache = ok and cache or {}

api.nvim_create_autocmd('VimLeavePre', {
  group = aug,
  callback = function() nv.file.write_json(cache_path, _G.icon_cache) end,
  desc = 'Save fs icon cache on exit',
})

---@param line string
---@return string|nil file
local function to_file(line)
  if not vim.tbl_contains({ '', './', '../' }, line) then
    if vim.b.netrw_curdir ~= nil then
      return vim.fs.joinpath(vim.b.netrw_curdir, line)
    end
    return line
  end
end

local M = {}

M.get = function(fname)
  local entry = icon_cache[fname]
  if not entry then
    local icon, hl = nv.ui.icons[Snacks.util.path_type(fname)](fname)
    entry = { icon = icon, hl = hl }
    icon_cache[fname] = entry
  end
  return entry
end

M.render = function(bufnr)
  bufnr = bufnr or api.nvim_get_current_buf()
  if not bufnr or not api.nvim_buf_is_valid(bufnr) then
    return
  end
  if vim.bo.filetype ~= 'directory' then
    return
  end
  api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
  local lines = api.nvim_buf_get_lines(bufnr, 0, api.nvim_buf_line_count(bufnr), false)

  for i, line in ipairs(lines) do
    local fname = fs.normalize(fs.abspath(fs.joinpath(api.nvim_buf_get_name(bufnr), line)))
    local entry = M.get(fname)
    api.nvim_buf_set_extmark(bufnr, ns, i - 1, 0, {
      sign_text = entry.icon,
      sign_hl_group = entry.hl,
      priority = 10,
    })
  end
  -- redraw to avoid flicker
  api.nvim__redraw({ buf = bufnr, valid = true, flush = false })
end

return M
