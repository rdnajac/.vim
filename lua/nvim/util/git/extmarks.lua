local nv = _G.nv or require('nvim.util')
local ns = vim.api.nvim_create_namespace('git-status')

---@class GitStatusCodes
---@field index string Single character status code for index
---@field working_tree string Single character status code for working tree

local function get_path(buffer)
  local ft = vim.bo[buffer].filetype
  return ft == 'oil' and require('oil').get_current_dir(buffer)
    or ft == 'netrw' and vim.b[buffer].netrw_curdir
end

local function get_line_name(buffer, n)
  local ft = vim.bo[buffer].filetype
  if ft == 'oil' then
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
  local git_root = vim.fn.FugitiveGitDir():gsub('/.git$', '')
  local rel_path = cwd:gsub('^' .. vim.pesc(git_root) .. '/?', '')
  local in_subdir = rel_path ~= '' and rel_path ~= cwd

  for _, line in ipairs(git_status_stdout) do
    local index_status = line:sub(1, 1)
    local working_status = line:sub(2, 2)
    local filename = line:sub(4):gsub('/$', '')

    if in_subdir then
      filename = vim.startswith(filename, rel_path .. '/') and filename:sub(#rel_path + 2) or nil
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
    local git_status = nv.git(nv.git.cmd('status', false), buffer)
    local git_tracked = nv.git(nv.git.cmd('tracked_cwd', false), buffer)
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

  local function get_extmark(code, priority)
    local k = nv.git.short_codes[code]
    return {
      sign_text = nv.icons.git[vim.fn.tolower(k or '')] or code,
      sign_hl_group = 'SnacksPickerGitStatus' .. (k or ''),
      priority = priority,
    }
  end

  for n = 1, vim.api.nvim_buf_line_count(buffer) do
    local name = get_line_name(buffer, n)
    if name then
      local codes = status[name]
      if codes then
        if codes.index ~= ' ' then
          vim.api.nvim_buf_set_extmark(buffer, ns, n - 1, 0, get_extmark(codes.index, 2))
        end
        if codes.working_tree ~= ' ' then
          vim.api.nvim_buf_set_extmark(buffer, ns, n - 1, 0, get_extmark(codes.working_tree, 1))
        end
      end
    end
  end
end

local aug = vim.api.nvim_create_augroup('git-extmarks', {})
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'oil', 'netrw' },
  group = aug,
  callback = function(ev)
    local buffer = ev.buf or vim.api.nvim_get_current_buf()
    if vim.b[buffer].git_status_started then
      return
    end
    vim.b[buffer].git_status_started = true

    local current_status, last_dir

    local function refresh()
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
    end

    refresh()
    vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufWritePost', 'BufEnter', 'DirChanged' }, {
      buffer = buffer,
      group = aug,
      callback = refresh,
    })
    vim.api.nvim_create_autocmd({ 'InsertLeave', 'TextChanged', 'CursorMoved' }, {
      buffer = buffer,
      group = aug,
      callback = refresh,
    })
  end,
})
