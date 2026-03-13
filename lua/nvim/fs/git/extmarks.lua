local git = require('nvim.util.git')
local ns = vim.api.nvim_create_namespace('git-status')

---@class GitStatusCodes
---@field index string Single character status code for index
---@field working_tree string Single character status code for working tree

local function get_path(buffer)
  local ft = vim.bo[buffer].filetype
  if ft == 'dirvish' then
    return vim.b[buffer].dirvish._dir
  elseif ft == 'oil' then
    return require('oil').get_current_dir(buffer)
  elseif ft == 'netrw' then
    return vim.b[buffer].netrw_curdir
  end
end

local function get_line_name(buffer, n)
  local ft = vim.bo[buffer].filetype
  if ft == 'dirvish' then
    local dir = vim.b[buffer].dirvish._dir
    local fname = vim.fn.getline(n):gsub('/$', '')
    local rel = fname:gsub('^' .. vim.pesc(dir), ''):gsub('^/', '')
    return rel
  elseif ft == 'oil' then
    local entry = require('oil').get_entry_on_line(buffer, n)
    return entry and entry.name ~= '..' and entry.name
  elseif ft == 'netrw' then
    local line = vim.fn.getline(n)
    local name = line:match('^%s*(.-)%s*$')
    if name and (name == '' or name == '..' or name:match('^"')) then
      return nil
    end
    return name and name:gsub('/$', '')
  end
end

---@param git_status_stdout string[] Lines from git status --porcelain
---@param git_ls_tree_stdout string[] Lines from git ls-tree
---@param cwd string Current working directory
---@return table<string, GitStatusCodes> Map of filename to status codes
local function parse_git_status(git_status_stdout, git_ls_tree_stdout, cwd)
  local status = {}
  local git_root = vim.fs.dirname(vim.fn.FugitiveGitDir())
  local rel_path =
    vim.fs.normalize(cwd):gsub('^' .. vim.pesc(vim.fs.normalize(git_root)) .. '/?', '')
  local in_subdir = rel_path ~= '' and rel_path ~= cwd

  for _, line in ipairs(git_status_stdout) do
    local index_status = line:sub(1, 1)
    local working_status = line:sub(2, 2)
    local filename = line:sub(4):gsub('/$', '')

    if in_subdir and filename then
      filename = vim.startswith(filename, rel_path .. '/') and filename:sub(#rel_path + 2)
    end

    if filename then
      local dir_index = filename:find('/')
      if dir_index then
        filename = filename:sub(1, dir_index - 1)
        if status[filename] then
          if index_status ~= ' ' then
            status[filename].index = 'M'
          end
          if working_status ~= ' ' then
            status[filename].working_tree = 'M'
          end
        else
          status[filename] = { index = index_status, working_tree = working_status }
        end
      else
        status[filename] = { index = index_status, working_tree = working_status }
      end
    end
  end

  for _, filename in ipairs(git_ls_tree_stdout) do
    status[filename] = status[filename] or { index = ' ', working_tree = ' ' }
  end

  return status
end

---@param buffer integer Buffer number
---@param callback fun(status?: table<string, GitStatusCodes>) Callback with status map or nil on error
local function load_git_status(buffer, callback)
  local path = get_path(buffer)
  if not path or vim.fn.FugitiveGitDir(path) == '' then
    return callback()
  end

  vim.schedule(function()
    local git_status = git(git.cmd('status', false), buffer)
    local git_tracked = git(git.cmd('tracked_cwd', false), buffer)
    if vim.tbl_isempty(git_status) and vim.tbl_isempty(git_tracked) then
      return callback()
    end
    callback(parse_git_status(git_status, git_tracked, path))
  end)
end

---@param buffer integer Buffer number
---@param status? table<string, GitStatusCodes> Map of filename to status codes
local function add_status_extmarks(buffer, status)
  vim.api.nvim_buf_clear_namespace(buffer, ns, 0, -1)
  if not status then
    return
  end

  local function get_icon(code)
    local k = git.short_codes[code]
    local icon = code
    return icon, 'SnacksPickerGitStatus' .. (k or '')
  end

  for n = 1, vim.api.nvim_buf_line_count(buffer) do
    local name = get_line_name(buffer, n)
    if not name then
      -- skip this line
    else
      local codes = status[name]
      if codes then
        local virt = {}

        if codes.index ~= ' ' then
          local icon, hl = get_icon(codes.index)
          table.insert(virt, { icon, hl })
        end

        if codes.working_tree ~= ' ' then
          local icon, hl = get_icon(codes.working_tree)
          table.insert(virt, { icon, hl })
        end

        if #virt > 0 then
          vim.api.nvim_buf_set_extmark(buffer, ns, n - 1, 0, {
            virt_text = virt,
            virt_text_pos = 'eol',
            priority = 1000,
            hl_mode = 'combine',
          })
        end
      end
    end
  end
end

local setup = function(ev)
  local buffer = ev and ev.buf or vim.api.nvim_get_current_buf()
  if vim.b[buffer].git_status_started then
    return
  end
  vim.b[buffer].git_status_started = true

  local current_status, last_dir

  local refresh = Snacks.util.debounce(function()
    local current_dir = get_path(buffer)
    if current_dir and current_dir ~= last_dir then
      last_dir = current_dir
      load_git_status(buffer, function(status)
        current_status = status
        add_status_extmarks(buffer, status)
      end)
    elseif current_status then
      add_status_extmarks(buffer, current_status)
    end
  end, { ms = 50 })

  refresh()

  vim.api.nvim_create_autocmd(
    { 'BufReadPost', 'BufWritePost', 'WinEnter', 'DirChanged', 'CursorMoved' },
    {
      buffer = buffer,
      group = aug,
      callback = refresh,
    }
  )
end

-- local aug = vim.api.nvim_create_augroup('git-extmarks', {})
-- vim.api.nvim_create_autocmd('FileType', {
--   pattern = { 'dirvish', 'oil', 'netrw' },
--   group = aug,
-- })

return { setup = setup }
