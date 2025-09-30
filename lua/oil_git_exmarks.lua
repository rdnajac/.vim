-- https://github.com/refractalize/oil-git-status.nvim
-- TODO: Merge with util/git_status
local ns = vim.api.nvim_create_namespace('oil-git-status')
local show_ignored = true
local function set_filename_status_code(filename, index_status_code, working_status_code, status)
  local dir_index = filename:find('/')
  if dir_index ~= nil then
    filename = filename:sub(1, dir_index - 1)

    if not status[filename] then
      status[filename] = {
        index = index_status_code,
        working_tree = working_status_code,
      }
    else
      if index_status_code ~= ' ' then
        status[filename].index = 'M'
      end
      if working_status_code ~= ' ' then
        status[filename].working_tree = 'M'
      end
    end
  else
    status[filename] = {
      index = index_status_code,
      working_tree = working_status_code,
    }
  end
end

--- @param s string
--- @return string
local function unquote_git_file_name(s)
  -- git-ls-tree and git-status show '\file".md' as `"\\file\".md"`.
  local out, _ = s:gsub('"(.*)"', '%1'):gsub('\\"', '"'):gsub('\\\\', '\\')
  return out
end

local function parse_git_status(git_status_stdout, git_ls_tree_stdout)
  local status_lines = vim.split(git_status_stdout, '\n')
  local status = {}
  for _, line in ipairs(status_lines) do
    local index_status_code = line:sub(1, 1)
    local working_status_code = line:sub(2, 2)
    local filename = unquote_git_file_name(line:sub(4))

    if vim.endswith(filename, '/') then
      filename = filename:sub(1, -2)
    end

    set_filename_status_code(filename, index_status_code, working_status_code, status)
  end

  for _, filename in ipairs(vim.split(git_ls_tree_stdout, '\n')) do
    filename = unquote_git_file_name(filename)
    if not status[filename] then
      status[filename] = { index = ' ', working_tree = ' ' }
    end
  end

  return status
end

local highlight_group_suffix_for_status_code = {
  ['!'] = 'Ignored',
  ['?'] = 'Untracked',
  ['A'] = 'Added',
  ['C'] = 'Copied',
  ['D'] = 'Deleted',
  ['M'] = 'Modified',
  ['R'] = 'Renamed',
  ['T'] = 'TypeChanged', -- XXX: ???
  ['U'] = 'Unmerged',
  [' '] = 'Unmodified', -- XXX: ???
}

local function highlight_group(code, index)
  return 'OilGitStatus'
    .. (index and 'Index' or 'WorkingTree')
    .. (highlight_group_suffix_for_status_code[code] or 'Unmodified')
end

local function get_symbol(code)
  local k = highlight_group_suffix_for_status_code[code]
  return nv.icons.git[vim.fn.tolower(k)] or code
end

local function add_status_extmarks(buffer, status)
  vim.api.nvim_buf_clear_namespace(buffer, ns, 0, -1)

  if status then
    for n = 1, vim.api.nvim_buf_line_count(buffer) do
      local entry = require('oil').get_entry_on_line(buffer, n)
      if entry and entry.name ~= '..' then
        local name = entry.name
        local status_codes = status[name] or (show_ignored and { index = '!', working_tree = '!' })

        if status_codes then
          vim.api.nvim_buf_set_extmark(buffer, ns, n - 1, 0, {
            sign_text = get_symbol(status_codes.index),
            sign_hl_group = highlight_group(status_codes.index, true),
            priority = 2,
          })
          vim.api.nvim_buf_set_extmark(buffer, ns, n - 1, 0, {
            sign_text = get_symbol(status_codes.working_tree),
            sign_hl_group = highlight_group(status_codes.working_tree, false),
            priority = 1,
          })
        end
      end
    end
  end
end

local function concurrent(fns, callback)
  local number_of_results = 0
  local results = {}

  for i, fn in ipairs(fns) do
    fn(function(args, ...)
      number_of_results = number_of_results + 1
      results[i] = args

      if number_of_results == #fns then
        callback(results, ...)
      end
    end)
  end
end

local function load_git_status(buffer, callback)
  local oil_url = vim.api.nvim_buf_get_name(buffer)
  local file_url = oil_url:gsub('^oil', 'file')
  local path = vim.uri_to_fname(file_url)
  concurrent({
    function(cb)
      -- quotepath=false - don't escape UTF-8 paths.
      vim.system({
        'git',
        '-c',
        'core.quotepath=false',
        '-c',
        'status.relativePaths=true',
        'status',
        '.',
        '--short',
      }, { text = true, cwd = path }, cb)
    end,
    function(cb)
      if show_ignored then
        -- quotepath=false - don't escape UTF-8 paths.
        vim.system(
          { 'git', '-c', 'core.quotepath=false', 'ls-tree', 'HEAD', '.', '--name-only' },
          { text = true, cwd = path },
          cb
        )
      else
        cb({ code = 0, stdout = '' })
      end
    end,
  }, function(results)
    vim.schedule(function()
      local git_status_results = results[1]
      local git_ls_tree_results = results[2]

      if git_ls_tree_results.code ~= 0 or git_status_results.code ~= 0 then
        return callback()
      end

      callback(parse_git_status(git_status_results.stdout, git_ls_tree_results.stdout))
    end)
  end)
end

---@return table<string, {hl_group: string, index: boolean, status_code: string}>
local generate_highlight_groups = function()
  local highlight_groups = {}
  for status_code, suffix in pairs(highlight_group_suffix_for_status_code) do
    table.insert(
      highlight_groups,
      { hl_group = 'OilGitStatusIndex' .. suffix, index = true, status_code = status_code }
    )
    table.insert(
      highlight_groups,
      { hl_group = 'OilGitStatusWorkingTree' .. suffix, index = false, status_code = status_code }
    )
  end
  return highlight_groups
end

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'oil',
  callback = function()
    local buffer = vim.api.nvim_get_current_buf()
    local current_status = nil

    if not vim.b[buffer].oil_git_status_started then
      vim.b[buffer].oil_git_status_started = true
      vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufWritePost' }, {
        buffer = buffer,
        callback = function()
          load_git_status(buffer, function(status)
            current_status = status
            add_status_extmarks(buffer, current_status)
          end)
        end,
      })

      vim.api.nvim_create_autocmd({ 'InsertLeave', 'TextChanged' }, {
        buffer = buffer,
        callback = function()
          if current_status then
            add_status_extmarks(buffer, current_status)
          end
        end,
      })
    end
  end,
})

vim.api.nvim_set_hl(0, 'OilGitStatusIndex', { link = 'DiagnosticSignInfo', default = true })
vim.api.nvim_set_hl(0, 'OilGitStatusWorkingTree', { link = 'DiagnosticSignWarn', default = true })

local highlight_groups = generate_highlight_groups()

for _, hl_group in ipairs(highlight_groups) do
  if hl_group.index then
    vim.api.nvim_set_hl(0, hl_group.hl_group, { link = 'OilGitStatusIndex', default = true })
  else
    vim.api.nvim_set_hl(0, hl_group.hl_group, { link = 'OilGitStatusWorkingTree', default = true })
  end
end
