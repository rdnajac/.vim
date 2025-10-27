-- Location:     after/ftplugin/netrw.lua
-- Maintainer:   Tim Pope <http://tpo.pe/>
-- Version:      2.0 (Lua port)
-- Description:  Vinegar.vim - enhance netrw file browser
--
-- This is a Lua port of the original vinegar.vim plugin by Tim Pope.
-- It provides enhancements to Vim's netrw file browser including:
-- - Quick navigation with '-' key
-- - Smart dotfile hiding/showing
-- - Better default settings for netrw
-- - Visual mode file path operations

-- Prevent loading if already loaded or version check fails
if vim.g.loaded_vinegar then
  return
end
vim.g.loaded_vinegar = 1

-- Local state module
local M = {}
M.dotfiles = [[\(^\|\s\s\)\zs\.\S\+]]
M.netrw_up = nil

-- Utility function to escape filenames for shell
-- Equivalent to fnameescape() in VimScript
local function fnameescape(file)
  if vim.fn.exists('*fnameescape') == 1 then
    return vim.fn.fnameescape(file)
  else
    return vim.fn.escape(file, " \t\n*?[{`$\\%#'\"|!<")
  end
end

-- Get the platform-appropriate path separator
-- Equivalent to s:slash() in VimScript
local function get_slash()
  if vim.o.shellslash then
    return '\\'
  else
    return '/'
  end
end

-- Create sort sequence pattern from suffixes option
-- Equivalent to s:sort_sequence() in VimScript
local function sort_sequence(suffixes)
  if suffixes == '' then
    return '[/]$,*'
  end

  local patterns = {}
  for _, suffix in ipairs(vim.split(suffixes, ',')) do
    if suffix ~= '' then
      local escaped = vim.fn.escape(suffix, '.*$~')
      table.insert(patterns, escaped)
    end
  end

  if #patterns > 0 then
    return '[/]$,*,\\%(' .. table.concat(patterns, '\\|') .. '\\)[*@]\\=$'
  else
    return '[/]$,*'
  end
end

-- Configure netrw list hiding based on wildignore and dotfiles
-- Sets up g:netrw_list_hide with patterns from wildignore
local function setup_netrw_list_hide()
  local wildignore = vim.o.wildignore
  local patterns = {}

  -- Process each wildignore pattern
  for _, pattern in ipairs(vim.split(wildignore, ',')) do
    if pattern ~= '' then
      -- Escape and convert wildcard pattern to regex
      local escaped = vim.fn.substitute(vim.fn.escape(pattern, '.$~'), '*', '.*', 'g')
      table.insert(patterns, '^' .. escaped .. '/\\=$')
    end
  end

  -- Start with converted patterns and add parent directory pattern
  local hide_list = table.concat(patterns, ',')
  if hide_list ~= '' then
    hide_list = hide_list .. ','
  end
  hide_list = hide_list .. '^\\.\\.\\=/\\=$'

  -- Add dotfiles pattern if it's not already at the end of existing netrw_list_hide
  local current_hide = vim.g.netrw_list_hide or ''
  local dotfiles_len = #M.dotfiles
  if current_hide == '' or current_hide:sub(-dotfiles_len) ~= M.dotfiles then
    hide_list = hide_list .. ',' .. M.dotfiles
  end

  vim.g.netrw_list_hide = hide_list
end

-- Set default netrw banner setting if not already set
if vim.g.netrw_banner == nil then
  vim.g.netrw_banner = 0
end

-- Initialize netrw settings
setup_netrw_list_hide()
vim.g.netrw_sort_sequence = sort_sequence(vim.o.suffixes)

-- Get absolute paths from netrw buffer lines
-- Equivalent to s:absolutes() in VimScript
local function get_absolutes(first, last)
  last = last or first
  local lines = vim.fn.getline(first, last)

  -- Handle both table and string returns from getline
  if type(lines) == 'string' then
    lines = { lines }
  end

  local files = {}
  for _, line in ipairs(lines) do
    -- Filter out comment lines (netrw comments start with ")
    if not line:match('^" ') then
      -- Remove tree view indicators (prefix like "| | ")
      local cleaned = vim.fn.substitute(line, [[^\(| \)*]], '', '')
      -- Get current directory from netrw buffer variable
      local curdir = vim.b.netrw_curdir or '.'
      -- Remove trailing file type markers and tabs
      local filename = vim.fn.substitute(cleaned, [=[[/*|@=]\=\%(\t.*\)\=$]=], '', '')
      if filename ~= '' then
        table.insert(files, curdir .. get_slash() .. filename)
      end
    end
  end

  return files
end

-- Convert absolute paths to relative paths
-- Equivalent to s:relatives() in VimScript
local function get_relatives(first, last)
  local files = get_absolutes(first, last)
  local result = {}

  for _, file in ipairs(files) do
    if not file:match('^" ') then
      local relative = vim.fn.fnamemodify(file, ':.')
      if relative ~= file then
        table.insert(result, '.' .. get_slash() .. relative)
      else
        table.insert(result, file)
      end
    end
  end

  return result
end

-- Get escaped relative paths for command line
-- Equivalent to s:escaped() in VimScript
local function get_escaped(first, last)
  local files = get_relatives(first, last)
  local escaped = {}

  for _, file in ipairs(files) do
    table.insert(escaped, fnameescape(file))
  end

  return table.concat(escaped, ' ')
end

-- Seek to a file in the netrw buffer
-- Equivalent to s:seek() in VimScript
local function seek(file)
  local pattern
  local liststyle = vim.b.netrw_liststyle or 0

  if liststyle == 2 then
    -- Wide listing format
    pattern = [[\%(^\|\s\+\)\zs]] .. vim.fn.escape(file, '.*[]~\\') .. [=[[/*|@=]\=\%($\|\s\+\)]=]
  else
    -- Thin or tree listing format
    pattern = [[^\%(| \)*]] .. vim.fn.escape(file, '.*[]~\\') .. [=[[/*|@=]\=\%($\|\t\)]=]
  end

  vim.fn.search(pattern, 'wc')
  return pattern
end

-- Open directory in netrw
-- Equivalent to s:opendir() in VimScript
local function opendir(cmd)
  local df = ',' .. M.dotfiles
  local current_hide = vim.g.netrw_list_hide or ''

  -- Toggle dotfile hiding if current file starts with '.'
  local current_file = vim.fn.expand('%:t')
  if current_file:sub(1, 1) == '.' and current_hide:sub(-#df) == df then
    vim.g.netrw_list_hide = current_hide:sub(1, -#df - 1)
  end

  -- Navigate based on current buffer type
  if vim.bo.filetype == 'netrw' and M.netrw_up and M.netrw_up ~= '' then
    local basename = vim.fn.fnamemodify(vim.b.netrw_curdir, ':t')
    vim.cmd(M.netrw_up)
    seek(basename)
  elseif vim.fn.expand('%') == '' or vim.fn.expand('%'):match('^term://') then
    vim.cmd(cmd .. ' .')
  else
    local dir = vim.fn.expand('%:h')
    -- Check if path is a URL-like path (protocol://)
    if vim.fn.expand('%:p'):match('^%a%a+:') then
      dir = dir .. get_slash()
    end
    vim.cmd(cmd .. ' ' .. dir)
    seek(vim.fn.expand('#:t'))
  end
end

-- Setup key mappings for netrw buffer
-- Equivalent to s:setup_vinegar() in VimScript
local function setup_vinegar()
  local bufnr = vim.api.nvim_get_current_buf()

  -- Detect and store existing '-' mapping for netrw navigation
  if M.netrw_up == nil then
    local orig = vim.fn.maparg('-', 'n')
    if orig ~= '' then
      -- Check if it's a <Plug> mapping
      if orig:match('^<[Pp]lug>') and orig ~= '<Plug>VinegarUp' then
        M.netrw_up = 'execute "normal \\' .. orig:gsub(' *$', '') .. '"'
      -- Check if it's a command mapping
      elseif orig:match('^:') then
        -- Remove :, <C-U>, and trailing <CR>
        M.netrw_up = orig:gsub('^:<[Cc]%-[Uu]>', ''):gsub('^:', ''):gsub('<[Cc][Rr]>$', '')
      else
        M.netrw_up = ''
      end
    else
      M.netrw_up = ''
    end
  end

  -- Map '-' to navigate up
  vim.keymap.set('n', '-', '<Plug>VinegarUp', { buffer = bufnr, silent = true })

  -- Map '~' to edit home directory
  vim.keymap.set('n', '~', ':edit ~/<CR>', { buffer = bufnr, silent = true })

  -- Map '.' for command-line with file paths (normal mode)
  vim.keymap.set('n', '.', function()
    local count = vim.v.count1
    local line = vim.fn.line('.')
    local escaped = get_escaped(line, line - 1 + count)
    -- Use feedkeys to enter command mode with file paths
    vim.api.nvim_feedkeys(':' .. escaped, 'n', false)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Home>', true, false, true), 'n', false)
  end, { buffer = bufnr, silent = true })

  -- Map '.' for command-line with file paths (visual mode)
  vim.keymap.set('x', '.', function()
    local start_line = vim.fn.line("'<")
    local end_line = vim.fn.line("'>")
    local escaped = get_escaped(start_line, end_line)
    -- Exit visual mode first
    vim.cmd('normal! ' .. vim.api.nvim_replace_termcodes('<Esc>', true, false, true))
    vim.api.nvim_feedkeys(':' .. escaped, 'n', false)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Home>', true, false, true), 'n', false)
  end, { buffer = bufnr, silent = true })

  -- Map 'y.' to yank absolute paths
  if vim.fn.mapcheck('y.', 'n') == '' then
    vim.keymap.set('n', 'y.', function()
      local count = vim.v.count1
      local line = vim.fn.line('.')
      local files = get_absolutes(line, line - 1 + count)
      local content = table.concat(files, '\n') .. '\n'
      vim.fn.setreg(vim.v.register, content)
    end, { buffer = bufnr, silent = true })
  end

  -- Map '!' shortcuts (. followed by !)
  vim.keymap.set('n', '!', '.!', { buffer = bufnr, remap = true })
  vim.keymap.set('x', '!', '.!', { buffer = bufnr, remap = true })

  -- Add syntax highlighting for suffixes
  local suffixes = vim.o.suffixes
  if suffixes ~= '' then
    local patterns = {}
    for _, suffix in ipairs(vim.split(suffixes, ',')) do
      if suffix ~= '' then
        local escaped = vim.fn.substitute(vim.fn.escape(suffix, '.$~'), '*', '.*', 'g')
        table.insert(patterns, escaped)
      end
    end
    if #patterns > 0 then
      local pattern = [[\%(\S\+ \)*\S\+\%(]] .. table.concat(patterns, '\\|') .. [=[[*@]\=\S\@!=]=]
      vim.cmd('syn match netrwSuffixes =' .. pattern .. '=')
      vim.cmd('hi def link netrwSuffixes SpecialKey')
    end
  end
end

-- Create global <Plug> mappings for VinegarUp
vim.keymap.set('n', '<Plug>VinegarUp', function()
  opendir('edit')
end, { silent = true })

vim.keymap.set('n', '<Plug>VinegarTabUp', function()
  opendir('tabedit')
end, { silent = true })

vim.keymap.set('n', '<Plug>VinegarSplitUp', function()
  opendir('split')
end, { silent = true })

vim.keymap.set('n', '<Plug>VinegarVerticalSplitUp', function()
  opendir('vsplit')
end, { silent = true })

-- Create default '-' mapping if not already mapped
if vim.fn.maparg('-', 'n') == '' and vim.fn.hasmapto('<Plug>VinegarUp', 'n') == 0 then
  vim.keymap.set('n', '-', '<Plug>VinegarUp', { silent = true })
end

-- Setup autocommands
local vinegar_group = vim.api.nvim_create_augroup('vinegar', { clear = true })

-- Setup vinegar when entering netrw buffer
vim.api.nvim_create_autocmd('FileType', {
  group = vinegar_group,
  pattern = 'netrw',
  callback = setup_vinegar,
})

-- Update sort sequence when suffixes option changes
vim.api.nvim_create_autocmd('OptionSet', {
  group = vinegar_group,
  pattern = 'suffixes',
  callback = function()
    local old_sequence = sort_sequence(vim.v.option_old)
    if old_sequence == vim.g.netrw_sort_sequence then
      vim.g.netrw_sort_sequence = sort_sequence(vim.v.option_new)
    end
  end,
})

return M
