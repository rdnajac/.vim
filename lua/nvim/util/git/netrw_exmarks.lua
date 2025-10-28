-- Git status extmarks for netrw buffers
local ns = vim.api.nvim_create_namespace('netrw-git-status')
local show_ignored = true

local M = {}

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
    if line and #line >= 3 then
      local index_status_code = line:sub(1, 1)
      local working_status_code = line:sub(2, 2)
      local filename = unquote_git_file_name(line:sub(4))

      if vim.endswith(filename, '/') then
        filename = filename:sub(1, -2)
      end

      set_filename_status_code(filename, index_status_code, working_status_code, status)
    end
  end

  for _, filename in ipairs(vim.split(git_ls_tree_stdout, '\n')) do
    filename = unquote_git_file_name(filename)
    if filename and filename ~= '' then
      if not status[filename] then
        status[filename] = { index = ' ', working_tree = ' ' }
      end
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
  ['T'] = 'TypeChanged',
  ['U'] = 'Unmerged',
  [' '] = 'Unmodified',
}

local function highlight_group(code, index)
  return 'NetrwGitStatus'
    .. (index and 'Index' or 'WorkingTree')
    .. (highlight_group_suffix_for_status_code[code] or 'Unmodified')
end

local function get_symbol(code)
  local k = highlight_group_suffix_for_status_code[code]
  -- Use simple symbols if icons not available
  local symbols = {
    ignored = '◌',
    untracked = '?',
    added = '+',
    copied = 'C',
    deleted = '-',
    modified = '●',
    renamed = 'R',
    typechanged = 'T',
    unmerged = '!',
    unmodified = ' ',
  }
  if k then
    return symbols[vim.fn.tolower(k)] or code
  end
  return ' '
end

--- Parse a netrw line to extract filename
--- Netrw lines can have various formats:
--- "  filename"
--- "  ../directory/"
--- "  [dir]/"
--- With icons: " 󰈙 filename"
--- @param line string
--- @return string|nil
local function parse_netrw_line(line)
  if not line or line == '' then
    return nil
  end

  -- Remove leading whitespace
  line = line:gsub('^%s+', '')

  -- Skip banner lines (start with "), empty lines, or navigation entries
  if line == '' or line:match('^"') or line == '../' or line == './' then
    return nil
  end

  -- Remove common icons/decorators (assuming they're Unicode characters or special markers)
  -- This pattern tries to extract just the filename
  -- Skip directory markers like [dir]
  if line:match('^%[.*%]') then
    return nil
  end

  -- Try to extract filename after any icon or marker
  -- Pattern: skip non-alphanumeric prefix, get the filename
  local filename = line:match('^[^%w%.%-_]*(.+)$')
  if filename then
    -- Clean up trailing markers like / for directories
    filename = filename:gsub('/$', '')
    -- Remove any trailing decorations
    filename = filename:gsub('%s+.*$', '')
    return filename
  end

  return nil
end

local function add_status_extmarks(buffer, status)
  vim.api.nvim_buf_clear_namespace(buffer, ns, 0, -1)

  if not status then
    return
  end

  local line_count = vim.api.nvim_buf_line_count(buffer)
  for n = 1, line_count do
    local ok, line = pcall(vim.api.nvim_buf_get_lines, buffer, n - 1, n, false)
    if not ok or not line[1] then
      goto continue
    end

    local filename = parse_netrw_line(line[1])
    if filename and filename ~= '..' then
      local status_codes = status[filename] or (show_ignored and { index = '!', working_tree = '!' })

      if status_codes then
        -- Set extmark for index status
        pcall(vim.api.nvim_buf_set_extmark, buffer, ns, n - 1, 0, {
          sign_text = get_symbol(status_codes.index),
          sign_hl_group = highlight_group(status_codes.index, true),
          priority = 2,
        })
        -- Set extmark for working tree status
        pcall(vim.api.nvim_buf_set_extmark, buffer, ns, n - 1, 0, {
          sign_text = get_symbol(status_codes.working_tree),
          sign_hl_group = highlight_group(status_codes.working_tree, false),
          priority = 1,
        })
      end
    end

    ::continue::
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

--- Get the directory path for a netrw buffer
--- @param buffer number
--- @return string|nil
local function get_netrw_dir(buffer)
  -- Try to get the directory from netrw's buffer variable
  local ok, dir = pcall(vim.api.nvim_buf_get_var, buffer, 'netrw_curdir')
  if ok and dir then
    return dir
  end

  -- Fallback: get from buffer name
  local bufname = vim.api.nvim_buf_get_name(buffer)
  if bufname and bufname ~= '' then
    -- If it's a directory path, use it
    if vim.fn.isdirectory(bufname) == 1 then
      return bufname
    end
    -- Otherwise, get the directory part
    return vim.fn.fnamemodify(bufname, ':h')
  end

  -- Final fallback: current directory
  return vim.fn.getcwd()
end

local function load_git_status(buffer, callback)
  local path = get_netrw_dir(buffer)
  if not path then
    callback()
    return
  end

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
local function generate_highlight_groups()
  local highlight_groups = {}
  for status_code, suffix in pairs(highlight_group_suffix_for_status_code) do
    table.insert(
      highlight_groups,
      { hl_group = 'NetrwGitStatusIndex' .. suffix, index = true, status_code = status_code }
    )
    table.insert(
      highlight_groups,
      { hl_group = 'NetrwGitStatusWorkingTree' .. suffix, index = false, status_code = status_code }
    )
  end
  return highlight_groups
end

M.setup = function()
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'netrw',
    callback = function()
      local buffer = vim.api.nvim_get_current_buf()
      local current_status = nil

      if not vim.b[buffer].netrw_git_status_started then
        vim.b[buffer].netrw_git_status_started = true

        -- Load git status on buffer events
        vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufWritePost', 'BufEnter' }, {
          buffer = buffer,
          callback = function()
            load_git_status(buffer, function(status)
              current_status = status
              add_status_extmarks(buffer, current_status)
            end)
          end,
        })

        -- Refresh extmarks when buffer content changes
        vim.api.nvim_create_autocmd({ 'TextChanged', 'TextChangedI' }, {
          buffer = buffer,
          callback = function()
            if current_status then
              add_status_extmarks(buffer, current_status)
            end
          end,
        })

        -- Initial load
        load_git_status(buffer, function(status)
          current_status = status
          add_status_extmarks(buffer, current_status)
        end)
      end
    end,
  })

  -- Set up highlight groups
  vim.api.nvim_set_hl(0, 'NetrwGitStatusIndex', { link = 'DiagnosticSignInfo', default = true })
  vim.api.nvim_set_hl(
    0,
    'NetrwGitStatusWorkingTree',
    { link = 'DiagnosticSignWarn', default = true }
  )

  local highlight_groups = generate_highlight_groups()

  for _, hl_group in ipairs(highlight_groups) do
    if hl_group.index then
      vim.api.nvim_set_hl(0, hl_group.hl_group, { link = 'NetrwGitStatusIndex', default = true })
    else
      vim.api.nvim_set_hl(
        0,
        hl_group.hl_group,
        { link = 'NetrwGitStatusWorkingTree', default = true }
      )
    end
  end
end

return M
