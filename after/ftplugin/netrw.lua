-- after/ftplugin/netrw.lua
-- Vinegar ftplugin for netrw buffers
-- Buffer-local configuration and mappings for netrw

-- Get the vinegar module (loaded by plugin/vinegar.lua)
local vinegar = _G.vinegar
if not vinegar then
  return
end

-- Setup the original netrw up mapping (only once)
if not vinegar.netrw_up then
  local orig = vim.fn.maparg('-', 'n')
  if orig:match('^<[Pp]lug>') and orig ~= '<Plug>VinegarUp' then
    vinegar.netrw_up = 'execute "normal \\' .. orig:gsub(' *$', '') .. '"'
  elseif orig:match('^:') then
    -- Remove :, <C-U>, and <CR> from the mapping
    vinegar.netrw_up = orig:gsub('^:[<Cc]%-[Uu]>', ''):gsub('<[Cc][Rr]>$', '')
  else
    vinegar.netrw_up = ''
  end
end

-- Map '-' to VinegarUp in this buffer
vim.keymap.set('n', '-', '<Plug>VinegarUp', { buffer = true, remap = true })

-- Expression mapping for getting file under cursor in command mode
local function get_cfile()
  local files = vinegar.relatives(vim.fn.line('.'), vim.fn.line('.'))
  if #files > 0 then
    return files[1]
  end
  return vim.api.nvim_replace_termcodes('<C-R><C-F>', true, true, true)
end

vim.keymap.set('c', '<Plug><cfile>', get_cfile, { buffer = true, expr = true })

-- Map Ctrl-R Ctrl-F if not already mapped
if vim.fn.maparg('<C-R><C-F>', 'c') == '' then
  vim.keymap.set('c', '<C-R><C-F>', '<Plug><cfile>', { buffer = true, remap = true })
end

-- Map ~ to edit home directory
vim.keymap.set('n', '~', ':edit ~/<CR>', { buffer = true })

-- Map . to start command with file under cursor
vim.keymap.set('n', '.', function()
  local count = vim.v.count1
  local first = vim.fn.line('.')
  local last = first + count - 1
  local escaped = vinegar.escaped(first, last)
  return ': ' .. escaped
end, { buffer = true, expr = true })

vim.keymap.set('x', '.', function()
  local first = vim.fn.line("'<")
  local last = vim.fn.line("'>")
  local escaped = vinegar.escaped(first, last)
  return '<Esc>: ' .. escaped
end, { buffer = true, expr = true })

-- Map y. to yank absolute paths (if not already mapped)
if vim.fn.mapcheck('y.', 'n') == '' then
  vim.keymap.set('n', 'y.', function()
    local count = vim.v.count1
    local first = vim.fn.line('.')
    local last = first + count - 1
    local files = vinegar.absolutes(first, last)
    local content = table.concat(files, '\n') .. '\n'
    vim.fn.setreg(vim.v.register, content)
  end, { buffer = true, silent = true })
end

-- Map ! to run shell command with file
vim.keymap.set('n', '!', '.!', { buffer = true, remap = true })
vim.keymap.set('x', '!', '.!', { buffer = true, remap = true })

-- Add syntax highlighting for suffixes
local suffixes = vim.o.suffixes
if suffixes ~= '' then
  local patterns = {}
  for suffix in vim.gsplit(suffixes, ',', { plain = true }) do
    if suffix ~= '' then
      local escaped = vim.fn.escape(suffix, '.*$~')
      escaped = escaped:gsub('%*', '.*')
      table.insert(patterns, escaped)
    end
  end

  if #patterns > 0 then
    local pattern = '\\%(\\S\\+ \\)*\\S\\+\\%('
      .. table.concat(patterns, '\\|')
      .. '\\)[*@]\\=\\S\\@!='
    vim.cmd('syn match netrwSuffixes =' .. pattern .. '=')
    vim.cmd('hi def link netrwSuffixes SpecialKey')
  end
end
