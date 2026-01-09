-- apply icons to special filesystem buffers like netrw and dirvish
local aug = vim.api.nvim_create_augroup('fs-icons', {})
local ns = vim.api.nvim_create_namespace('fs-icons')
-- `~/.local/share/nvim/cache/fs-icons.json`
local cache_path = vim.fn.stdpath('cache') .. '/fs-icons.json'
local ok, cache = pcall(nv.file.read_json, cache_path)
_G.icon_cache = ok and cache or {}

vim.api.nvim_create_autocmd('VimLeavePre', {
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
    local icon, hl = nv.icons[Snacks.util.path_type(fname)](fname)
    entry = { icon = icon, hl = hl }
    icon_cache[fname] = entry
  end
  return entry
end

M.render = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end
  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, vim.api.nvim_buf_line_count(bufnr), false)

  for i, line in ipairs(lines) do
    local fname = to_file(line)
    if fname then
      local entry = M.get(fname)
      -- dd(entry)
      vim.api.nvim_buf_set_extmark(bufnr, ns, i - 1, 0, {
        sign_text = entry.icon,
        sign_hl_group = entry.hl,
        priority = 10,
      })
    end
  end
  -- PERF: force redraw to avoid flicker
  nv.fn.defer_redraw(50)
end

return M
