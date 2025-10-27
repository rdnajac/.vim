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
--
-- Note: This is an ftplugin, so it runs each time a netrw buffer is opened.
-- Global setup is guarded to run only once.

-- Initialize global state on first load
if not vim.g.loaded_vinegar then
  vim.g.loaded_vinegar = 1

  -- Module for shared state
  _G.vinegar = _G.vinegar or {}
  _G.vinegar.dotfiles = [[\(^\|\s\s\)\zs\.\S\+]]
  _G.vinegar.netrw_up = nil

  -- Create sort sequence pattern from suffixes option
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
    local dotfiles_len = #_G.vinegar.dotfiles
    if current_hide == '' or current_hide:sub(-dotfiles_len) ~= _G.vinegar.dotfiles then
      hide_list = hide_list .. ',' .. _G.vinegar.dotfiles
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

  -- Get the platform-appropriate path separator
  _G.vinegar.get_slash = function()
    if vim.o.shellslash then
      return '\\'
    else
      return '/'
    end
  end

  -- Utility function to escape filenames for shell
  _G.vinegar.fnameescape = function(file)
    if vim.fn.exists('*fnameescape') == 1 then
      return vim.fn.fnameescape(file)
    else
      return vim.fn.escape(file, " \t\n*?[{`$\\%#'\"|!<")
    end
  end

  -- Get absolute paths from netrw buffer lines
  _G.vinegar.get_absolutes = function(first, last)
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
          table.insert(files, curdir .. _G.vinegar.get_slash() .. filename)
        end
      end
    end

    return files
  end

  -- Convert absolute paths to relative paths
  _G.vinegar.get_relatives = function(first, last)
    local files = _G.vinegar.get_absolutes(first, last)
    local result = {}

    for _, file in ipairs(files) do
      if not file:match('^" ') then
        local relative = vim.fn.fnamemodify(file, ':.')
        if relative ~= file then
          table.insert(result, '.' .. _G.vinegar.get_slash() .. relative)
        else
          table.insert(result, file)
        end
      end
    end

    return result
  end

  -- Get escaped relative paths for command line
  _G.vinegar.get_escaped = function(first, last)
    local files = _G.vinegar.get_relatives(first, last)
    local escaped = {}

    for _, file in ipairs(files) do
      table.insert(escaped, _G.vinegar.fnameescape(file))
    end

    return table.concat(escaped, ' ')
  end

  -- Seek to a file in the netrw buffer
  _G.vinegar.seek = function(file)
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
  _G.vinegar.opendir = function(cmd)
    local df = ',' .. _G.vinegar.dotfiles
    local current_hide = vim.g.netrw_list_hide or ''

    -- Toggle dotfile hiding if current file starts with '.'
    local current_file = vim.fn.expand('%:t')
    if current_file:sub(1, 1) == '.' and current_hide:sub(-#df) == df then
      vim.g.netrw_list_hide = current_hide:sub(1, -#df - 1)
    end

    -- Navigate based on current buffer type
    if vim.bo.filetype == 'netrw' and _G.vinegar.netrw_up and _G.vinegar.netrw_up ~= '' then
      local basename = vim.fn.fnamemodify(vim.b.netrw_curdir, ':t')
      vim.cmd(_G.vinegar.netrw_up)
      _G.vinegar.seek(basename)
    elseif vim.fn.expand('%') == '' or vim.fn.expand('%'):match('^term://') then
      vim.cmd(cmd .. ' .')
    else
      local dir = vim.fn.expand('%:h')
      -- Check if path is a URL-like path (protocol://)
      if vim.fn.expand('%:p'):match('^%a%a+:') then
        dir = dir .. _G.vinegar.get_slash()
      end
      vim.cmd(cmd .. ' ' .. dir)
      _G.vinegar.seek(vim.fn.expand('#:t'))
    end
  end

  -- Create global <Plug> mappings for VinegarUp (only once)
  vim.keymap.set('n', '<Plug>VinegarUp', function()
    _G.vinegar.opendir('edit')
  end, { silent = true })

  vim.keymap.set('n', '<Plug>VinegarTabUp', function()
    _G.vinegar.opendir('tabedit')
  end, { silent = true })

  vim.keymap.set('n', '<Plug>VinegarSplitUp', function()
    _G.vinegar.opendir('split')
  end, { silent = true })

  vim.keymap.set('n', '<Plug>VinegarVerticalSplitUp', function()
    _G.vinegar.opendir('vsplit')
  end, { silent = true })

  -- Create default '-' mapping if not already mapped
  if vim.fn.maparg('-', 'n') == '' and vim.fn.hasmapto('<Plug>VinegarUp', 'n') == 0 then
    vim.keymap.set('n', '-', '<Plug>VinegarUp', { silent = true })
  end

  -- Setup autocommands (only once)
  local vinegar_group = vim.api.nvim_create_augroup('vinegar', { clear = true })

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
end

-- Buffer-local setup (runs each time a netrw buffer is opened)
local bufnr = vim.api.nvim_get_current_buf()

-- Detect and store existing '-' mapping for netrw navigation
if _G.vinegar.netrw_up == nil then
  local orig = vim.fn.maparg('-', 'n')
  if orig ~= '' then
    -- Check if it's a <Plug> mapping
    if orig:match('^<[Pp]lug>') and orig ~= '<Plug>VinegarUp' then
      _G.vinegar.netrw_up = 'execute "normal \\' .. orig:gsub(' *$', '') .. '"'
    -- Check if it's a command mapping
    elseif orig:match('^:') then
      -- Remove :, <C-U>, and trailing <CR>
      _G.vinegar.netrw_up = orig:gsub('^:<[Cc]%-[Uu]>', ''):gsub('^:', ''):gsub('<[Cc][Rr]>$', '')
    else
      _G.vinegar.netrw_up = ''
    end
  else
    _G.vinegar.netrw_up = ''
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
  local escaped = _G.vinegar.get_escaped(line, line - 1 + count)
  -- Use feedkeys to enter command mode with file paths
  vim.api.nvim_feedkeys(':' .. escaped, 'n', false)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Home>', true, false, true), 'n', false)
end, { buffer = bufnr, silent = true })

-- Map '.' for command-line with file paths (visual mode)
vim.keymap.set('x', '.', function()
  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")
  local escaped = _G.vinegar.get_escaped(start_line, end_line)
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
    local files = _G.vinegar.get_absolutes(line, line - 1 + count)
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
