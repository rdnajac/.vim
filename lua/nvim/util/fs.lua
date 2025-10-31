---@type table
_G.icon_cache = {} -- TODO: write to file

local aug = vim.api.nvim_create_augroup('fs-icons', {})
local ns = vim.api.nvim_create_namespace('fs-icons')
local nv = _G.nv or require('nvim.util')

local M = {}

---@param line string
---@return string|nil file
local function to_file(line)
  if type(line) == 'string' and line ~= '' then
    -- local name = line:gsub('^[|%s]*', ''):match('^[^%s]+')
    if line and not (line == './' or line == '../' or vim.startswith(line, '"')) then
      local dir = vim.b.netrw_curdir or vim.b.dirvish._dir or ''
      return vim.fs.joinpath(dir, line)
    end
  end
end

M.apply_icons = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end
  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, vim.api.nvim_buf_line_count(bufnr), false)

  for i, line in ipairs(lines) do
    local fname = to_file(line)
    if fname then
      local entry = icon_cache[fname]
      if not entry then
        -- get icon and hl from MiniIcons, handling dirs and trailing * for executables
        local icon, hl =
          nv.icons[vim.endswith(fname, '/') and 'directory' or 'file'](fname:gsub('*$', ''))
        entry = { icon = icon, hl = vim.endswith(fname, '*') and 'MiniIconsRed' or hl }
        icon_cache[fname] = entry
      end
      vim.api.nvim_buf_set_extmark(bufnr, ns, i - 1, 0, {
        sign_text = entry.icon,
        sign_hl_group = entry.hl,
        priority = 10,
      })
    end
  end
end

return M

-- TODO: convert snacks example for netrw to dirvish
-- vim.api.nvim_create_autocmd({ 'FileType' }, {
--   pattern = { 'netrw' },
--   group = vim.api.nvim_create_augroup('NetrwOnRename', { clear = true }),
--   callback = function()
--     vim.keymap.set('n', 'R', function()
--       local original_file_path = vim.b.netrw_curdir .. '/' .. vim.fn['netrw#Call']('NetrwGetWord')
--
--       vim.ui.input(
--         { prompt = 'Move/rename to:', default = original_file_path },
--         function(target_file_path)
--           if target_file_path and target_file_path ~= '' then
--             local file_exists = vim.uv.fs_access(target_file_path, 'W')
--
--             if not file_exists then
--               vim.uv.fs_rename(original_file_path, target_file_path)
--
--               Snacks.rename.on_rename_file(original_file_path, target_file_path)
--             else
--               vim.notify(
--                 "File '" .. target_file_path .. "' already exists! Skipping...",
--                 vim.log.levels.ERROR
--               )
--             end
--
--             -- Refresh netrw
--             vim.cmd(':Ex ' .. vim.b.netrw_curdir)
--           end
--         end
--       )
--     end, { remap = true, buffer = true })
--   end,
-- })
