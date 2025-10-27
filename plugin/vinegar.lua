-- plugin/vinegar.lua
-- Combine with netrw to create a delicious salad dressing
-- Originally by Tim Pope <http://tpo.pe/>
-- Rewritten in Lua for Neovim

-- Don't load if already loaded
if vim.g.loaded_vinegar then
  return
end
vim.g.loaded_vinegar = 1

-- Module for vinegar functionality
local M = {}

-- Escape filename for shell commands
---@param file string
---@return string
local function fnameescape(file)
  return vim.fn.fnameescape(file)
end

-- Get the appropriate slash for the system
---@return string
local function slash()
  if vim.o.shellslash or not vim.fn.has('win32') then
    return '/'
  else
    return '\\'
  end
end

-- Convert suffixes to sort sequence pattern
---@param suffixes string
---@return string
local function sort_sequence(suffixes)
  if suffixes == '' then
    return '[/]$,*'
  end

  local patterns = {}
  for suffix in vim.gsplit(suffixes, ',', { plain = true }) do
    if suffix ~= '' then
      -- Escape special regex characters
      local escaped = vim.fn.escape(suffix, '.*$~')
      table.insert(patterns, escaped)
    end
  end

  if #patterns == 0 then
    return '[/]$,*'
  end

  return '[/]$,*,\\%(' .. table.concat(patterns, '\\|') .. '\\)[*@]\\=$'
end

-- Setup netrw configuration
local dotfiles = '\\(^\\|\\s\\s\\)\\zs\\.\\S\\+'

-- Build netrw_list_hide from wildignore
local hide_patterns = {}
for pattern in vim.gsplit(vim.o.wildignore, ',', { plain = true }) do
  if pattern ~= '' then
    local escaped = vim.fn.escape(pattern, '.$~')
    escaped = escaped:gsub('%*', '.*')
    table.insert(hide_patterns, '^' .. escaped .. '/\\=$')
  end
end
table.insert(hide_patterns, '^\\.\\.\\/\\=$')

-- Check if existing netrw_list_hide ends with dotfiles pattern
-- If it does, preserve it in the new list
-- Note: This preserves user's choice - if they had dotfiles hidden, keep them hidden
-- If they didn't, don't force it. Vinegar doesn't hide dotfiles by default.
local existing_hide = vim.g.netrw_list_hide or ''
local dotfiles_with_comma = ',' .. dotfiles
local check_len = #dotfiles_with_comma

if #existing_hide >= check_len and existing_hide:sub(-check_len) == dotfiles_with_comma then
  table.insert(hide_patterns, dotfiles)
end

vim.g.netrw_list_hide = table.concat(hide_patterns, ',')

-- Set netrw banner off by default
if vim.g.netrw_banner == nil then
  vim.g.netrw_banner = 0
end

-- Set netrw sort sequence
vim.g.netrw_sort_sequence = sort_sequence(vim.o.suffixes)

-- Track the original netrw up mapping
M.netrw_up = nil

-- Get absolute paths from netrw buffer lines
---@param first number
---@param last number
---@return table
function M.absolutes(first, last)
  local files = vim.api.nvim_buf_get_lines(0, first - 1, last, false)
  local results = {}

  -- Get current netrw directory
  local curdir = vim.b.netrw_curdir
  if not curdir then
    return results
  end

  for _, line in ipairs(files) do
    -- Skip comment lines (lines starting with '" ')
    if not line:match('^" ') then
      -- Remove tree characters (prefix '| ' repeated)
      while line:match('^| ') do
        line = line:sub(3) -- Remove '| '
      end
      -- Remove trailing markers and optional tab with text
      -- Pattern: [/*|@=] optionally followed by tab and anything
      line = line:gsub('[/*|@=][\t].*$', '')
      line = line:gsub('[/*|@=]$', '')

      if line ~= '' then
        table.insert(results, curdir .. slash() .. line)
      end
    end
  end

  return results
end

-- Get relative paths from netrw buffer lines
---@param first number
---@param last number
---@return table
function M.relatives(first, last)
  local files = M.absolutes(first, last)
  local results = {}

  for _, file in ipairs(files) do
    -- Skip comment lines again for safety
    if not file:match('^" ') then
      local relative = vim.fn.fnamemodify(file, ':.')
      if relative ~= file then
        table.insert(results, '.' .. slash() .. relative)
      else
        table.insert(results, file)
      end
    end
  end

  return results
end

-- Get escaped relative paths for command line
---@param first number
---@param last number
---@return string
function M.escaped(first, last)
  local files = M.relatives(first, last)
  local escaped = {}

  for _, file in ipairs(files) do
    table.insert(escaped, fnameescape(file))
  end

  return table.concat(escaped, ' ')
end

-- Seek to a file in netrw buffer
---@param file string
function M.seek(file)
  local pattern
  local liststyle = vim.b.netrw_liststyle or 0

  if liststyle == 2 then
    -- Wide listing
    pattern = '\\%(^\\|\\s\\+\\)\\zs'
      .. vim.fn.escape(file, '.*[]~\\')
      .. '[/*|@=]\\=\\%($\\|\\s\\+\\)'
  else
    -- Thin or tree listing
    pattern = '^\\%(| \\)*' .. vim.fn.escape(file, '.*[]~\\') .. '[/*|@=]\\=\\%($\\|\\t\\)'
  end

  vim.fn.search(pattern, 'wc')
end

-- Open parent directory
---@param cmd string
function M.opendir(cmd)
  local df = ',' .. dotfiles
  local current_file = vim.fn.expand('%:t')

  -- Toggle dotfiles visibility
  if current_file:sub(1, 1) == '.' and vim.g.netrw_list_hide:sub(-#df) == df then
    vim.g.netrw_list_hide = vim.g.netrw_list_hide:sub(1, -#df - 1)
  end

  if vim.bo.filetype == 'netrw' and M.netrw_up and M.netrw_up ~= '' then
    -- Already in netrw, go up one level
    local basename = vim.fn.fnamemodify(vim.b.netrw_curdir, ':t')
    vim.cmd(M.netrw_up)
    M.seek(basename)
  elseif vim.fn.expand('%') == '' or vim.fn.expand('%'):match('^term://') then
    -- Empty buffer or terminal, explore current directory
    vim.cmd(cmd .. ' .')
  else
    -- Open parent directory of current file
    local parent = vim.fn.expand('%:h')
    if vim.fn.expand('%:p'):match('^%a%a+:') then
      parent = parent .. slash()
    end
    vim.cmd(cmd .. ' ' .. vim.fn.fnameescape(parent))
    M.seek(vim.fn.expand('#:t'))
  end
end

-- Create mappings
vim.keymap.set('n', '<Plug>VinegarUp', function()
  M.opendir('edit')
end, { silent = true, desc = 'Open parent directory' })

vim.keymap.set('n', '<Plug>VinegarTabUp', function()
  M.opendir('tabedit')
end, { silent = true, desc = 'Open parent directory in new tab' })

vim.keymap.set('n', '<Plug>VinegarSplitUp', function()
  M.opendir('split')
end, { silent = true, desc = 'Open parent directory in split' })

vim.keymap.set('n', '<Plug>VinegarVerticalSplitUp', function()
  M.opendir('vsplit')
end, { silent = true, desc = 'Open parent directory in vertical split' })

-- Map '-' to VinegarUp if not already mapped
if vim.fn.maparg('-', 'n') == '' and not vim.fn.hasmapto('<Plug>VinegarUp', 'n') then
  vim.keymap.set('n', '-', '<Plug>VinegarUp', { remap = true })
end

-- Setup autocmd for suffixes option changes
vim.api.nvim_create_autocmd('OptionSet', {
  pattern = 'suffixes',
  group = vim.api.nvim_create_augroup('vinegar', { clear = true }),
  callback = function()
    local old_seq = sort_sequence(vim.v.option_old)
    if old_seq == vim.g.netrw_sort_sequence then
      vim.g.netrw_sort_sequence = sort_sequence(vim.v.option_new)
    end
  end,
})

-- Export module for use by ftplugin
_G.vinegar = M

return M
