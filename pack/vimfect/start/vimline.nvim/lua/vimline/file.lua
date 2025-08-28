local M = {}

local icons = nvim.icons

--- Return file format icon ( one of { unix, dos, mac })
--- @param bufnr? integer Optional buffer number (defaults to current buffer)
M.format = function(bufnr)
  return (icons[vim.bo[bufnr or 0].fileformat] or vim.bo[bufnr or 0].fileformat)
end

-- TODO: accept bufnr?
M.size = function()
  local size = vim.fn.getfsize(vim.fn.expand('%:p'))

  if size <= 0 then
    return ''
  end

  local suffixes = { 'b', 'k', 'm', 'g' }
  local i = 1

  while size > 1024 and i < #suffixes do
    size = size / 1024
    i = i + 1
  end

  return string.format(i == 1 and '%d%s' or '%.1f%s', size, suffixes[i])
end

---Return a nicely shortened filename + status symbols.
---@param opts? table
---  opts.path: 0=tail,1=rel,2=abs,3=abs~,4=parent/leaf  (default 0)
---  opts.short_target: columns to leave free (0 = no shorten) (default 40)
---  opts.file_status: boolean show [+]/[RO] (default true)
---  opts.newfile_status: boolean show [N] for new file (default true)
---  opts.symbols: table { unnamed='[No Name]', modified='', readonly='', newfile='' }
---  opts.globalstatus: boolean (same meaning as lualine) (default false)
---@return string
M.name = function(opts)
  opts = opts or {}
  local path_mode = opts.path or 0
  local short_target = opts.short_target or 40
  local file_status = opts.file_status ~= false
  local newfile_status = opts.newfile_status ~= false
  local symbols = opts.symbols
    or {
      unnamed = '[No Name]',
      modified = '',
      readonly = '',
      newfile = '',
    }

  local sep = package.config:sub(1, 1)

  local function is_new_file()
    local fn = vim.fn.expand('%')
    return fn ~= '' and fn:match('^%a+://') == nil and vim.bo.buftype == '' and vim.fn.filereadable(fn) == 0
  end

  local function shorten(path, max_len)
    if #path <= max_len then
      return path
    end
    local segs = vim.split(path, sep)
    for i = 1, #segs - 1 do
      if #path <= max_len then
        break
      end
      local s = segs[i]
      local short = s:sub(1, vim.startswith(s, '.') and 2 or 1)
      segs[i] = short
      path = path:sub(1, 0) -- noop, we recompute len below
      -- recompute quickly:
      -- (#original - #replaced) = delta
    end
    return table.concat(segs, sep)
  end

  local function parent_leaf(p)
    local segs = vim.split(p, sep)
    local n = #segs
    return n <= 1 and p or (segs[n - 1] .. sep .. segs[n])
  end

  -- path pick
  local data
  if path_mode == 1 then
    data = vim.fn.expand('%:~:.')
  elseif path_mode == 2 then
    data = vim.fn.expand('%:p')
  elseif path_mode == 3 then
    data = vim.fn.expand('%:p:~')
  elseif path_mode == 4 then
    data = parent_leaf(vim.fn.expand('%:p:~'))
  else
    data = vim.fn.expand('%:t')
  end
  if data == '' then
    data = symbols.unnamed
  end

  if short_target ~= 0 then
    local ww = opts.globalstatus and vim.go.columns or vim.fn.winwidth(0)
    data = shorten(data, ww - short_target)
  end

  data = vim.fn.substitute(data, [[\%#]], [[\%#]], 'g') -- escape % and |
  data = vim.fn.substitute(data, [[\|]], [[\|]], 'g')

  local marks = {}
  if file_status then
    if vim.bo.modified then
      marks[#marks + 1] = symbols.modified
    end
    if (vim.bo.modifiable == false) or vim.bo.readonly then
      marks[#marks + 1] = symbols.readonly
    end
  end
  if newfile_status and is_new_file() then
    marks[#marks + 1] = symbols.newfile
  end

  return marks[1] and (data .. ' ' .. table.concat(marks, '')) or data
end

return M
