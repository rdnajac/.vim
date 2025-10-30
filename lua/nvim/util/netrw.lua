-- _G.netrw_icons_cache = vim.defaulttable()
---@type table
-- TODO: write to file
_G.icon_cache = {}

-- TODO: hide dot and dotdot in netrw listings
local nv = _G.nv or require('nvim.util')
local ns = vim.api.nvim_create_namespace('netrw-icons')
local M = {}

M.statusline = function()
  local bufnr_ok = vim.w.netrw_explore_bufnr
    and vim.w.netrw_explore_bufnr == vim.api.nvim_get_current_buf()
  local line_ok = vim.w.netrw_explore_line and vim.w.netrw_explore_line == vim.fn.line('.')
  local list_ok = vim.w.netrw_explore_list ~= nil

  if not (bufnr_ok and line_ok and list_ok) then
    -- vim.o.stl = vim.g.netrw_explore_stl or '' -- fallback statusline
    vim.w.netrw_explore_bufnr = nil
    vim.w.netrw_explore_line = nil
    return ''
  else
    local cnt = vim.w.netrw_explore_mtchcnt or 0
    local len = vim.w.netrw_explore_listlen or 0
    return string.format('Match %d of %d', cnt, len)
  end
end

M.winbar = function()
  local a = nv.icons.directory[vim.b.netrw_curdir] .. '%{fnamemodify(b:netrw_curdir, ":~")}'
  local b = 'w:netrw_liststyle = %{w:netrw_liststyle}'
  -- local c = ' %{NetrwStatusLine()}'
  -- local c = ' NetrwStatusLine()'
  -- local c = vim.fn.NetrwStatusLine()
  -- local c = M.statusline()
  local c = ' bufnr=%b'
  return nv.winbar.render(a, b, c)
end

---@enum netrw.Liststyle
M.liststyle = {
  Thin = 0,
  Long = 1,
  Wide = 2,
  Tree = 3,
}

---@return netrw.Liststyle
M.window_liststyle = function()
  return vim.w.netrw_liststyle
end

---@param bufnr? number
---@return string[]
local function get_buffer_lines(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  return vim.api.nvim_buf_get_lines(bufnr, 0, vim.api.nvim_buf_line_count(bufnr), false)
end

---@param line number
---@param col? number default 1
---@param trans? number 0 or 1, default 1
local is_netrwComment = function(line, col, trans)
  -- TODO: util function to check against multiple synnames
  local synname = vim.fn.synIDattr(vim.fn.synID(line, col or 1, trans or 1), 'name')
  return synname == 'netrwComment' or synname == 'netrwHide'
end

---@param line string
---@return string|nil file
local function to_file(line)
  if type(line) == 'string' and line ~= '' then
    -- PERF: check window liststyle first
    -- remove leading whitespace and bars
    -- take the first token before whitespace
    local name = line:gsub('^[|%s]*', ''):match('^[^%s]+')
    if name and not (name == './' or name == '../' or vim.startswith(name, '"')) then
      return vim.fs.joinpath(vim.b.netrw_curdir, name)
    end
  end
end

local function test_regex()
  local lines = {}
  for line in io.lines('NetrwTreeListing') do
    table.insert(lines, line)
  end

  return vim.tbl_map(function(line)
    local name = line:gsub('^[|%s]*', ''):match('^[^%s]+')
    return name
  end, lines)
end

local function apply_icons(bufnr)
  -- if not buffer or not vim.api.nvim_buf_is_valid(buffer) then return end
  local curdir = vim.b[bufnr].netrw_curdir
  if not curdir or M.window_liststyle() == 2 then
    return
  end

  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

  for i, line in ipairs(get_buffer_lines(bufnr)) do
    local fname = to_file(line)
    if fname then
      local entry = icon_cache[fname]
      if not entry then
        local is_dir = vim.fn.isdirectory(fname) == 1
        local icon, hl = nv.icons[is_dir and 'directory' or 'file'](fname)
        entry = { icon = icon, hl = hl }
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

function M.setup()
  local aug = vim.api.nvim_create_augroup('netrw-mini-icons', {})

  vim.api.nvim_create_autocmd('FileType', {
    group = aug,
    pattern = 'netrw',
    callback = function(ev)
      apply_icons(ev.buf)
    end,
  })

  vim.api.nvim_create_autocmd('BufWinEnter', {
    group = aug,
    callback = function(ev)
      local buf = ev.buf
      if not vim.api.nvim_buf_is_valid(buf) or vim.bo[buf].filetype ~= 'netrw' then
        return
      end
      vim.schedule(function()
        apply_icons(buf)
      end)
    end,
  })
end

return M
