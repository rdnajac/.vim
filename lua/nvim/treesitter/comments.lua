local M = {}

M._get_option = vim.filetype.get_option

---@param cs string
function M.norm(cs)
  return vim.trim(cs:gsub('%s*%%s%s*', ' %%s '))
end

local function get_comments(ft)
  local cc = M._get_option(ft, 'comments')
  if cc == vim.opt.comments._info.default then
    return {}
  end
  return vim.tbl_filter(
    function(str)
      return str ~= false
    end,
    vim.tbl_map(function(cs)
      local flags, str = cs:match('^(.-):(.*)$')
      return flags and not flags:match('[fsme]') and (str .. ' %s') or false
    end, vim.split(cc, ',') or {})
  )
end

---@return string|string[]|nil
local function resolve_ts(spec)
  local line = vim.fn.getline('.')
  local pos = vim.api.nvim_win_get_cursor(0)
  local indent = line:match('^%s*()')
  -- nvim_win_get_cursor returns (1,0) indexed tuple
  -- treesitter.get_node expects (0,0) indexed tuple
  pos[1] = pos[1] - 1
  -- set position to the first non whitespace character
  if indent and pos[2] < indent - 1 then
    pos[2] = indent - 1
  end
  local ok, node = pcall(vim.treesitter.get_node, {
    ignore_injections = false, -- include injected languages
    pos = pos,
  })
  while ok and node do
    if spec[node:type()] then
      return spec[node:type()] -- found a commentstring for the current node
    end
    node = node:parent()
  end
end

-- Resolves the possible commentstrings for a given filetype in the current line
---@param ft string
---@return string[]
function M.resolve(ft)
  local lang = vim.treesitter.language.get_lang(ft) or ft
  local spec = require('nvim.treesitter.commentspec').lang[lang]
  local ret = {} ---@type string[]

  local have = {} ---@type table<string, boolean>
  local function add(a)
    if type(a) == 'string' then
      a = M.norm(a)
      if not have[a] and a ~= '' then
        have[a] = true
        ret[#ret + 1] = a
      end
    elseif type(a) == 'table' then
      add(a[1]) -- add first one (used for commenting) and then add all the others (uncommenting)
      ---@diagnostic disable-next-line: no-unknown
      for _, v in pairs(a) do
        add(v)
      end
    end
  end

  if type(spec) == 'table' and not vim.islist(spec) then
    add(resolve_ts(spec))
  end

  add(spec) -- always add all found patterns
  add(M._get_option(ft, 'commentstring')) -- always include the commentstring from the buffer
  add(get_comments(ft))
  if #ret > 0 then
    local first = table.remove(ret, 1)
    table.sort(ret)
    table.insert(ret, 1, first)
  end
  return ret
end

---@param ft string
function M.get(ft)
  local patterns = M.resolve(ft)
  local line = vim.fn.getline('.')

  local cs = nil
  local n = math.huge
  for _, pattern in ipairs(patterns) do -- check all patterns to check if we want to uncomment
    local left, right = pattern:match('^%s*(.-)%s*%%s%s*(.-)%s*$') -- parse commentstring excluding whitespace
    if left and right then
      local l, m, r = line:match('^%s*' .. vim.pesc(left) .. '(%s*)(.-)(%s*)' .. vim.pesc(right) .. '%s*$')
      if m and #m < n then -- most commented line
        cs = vim.trim(left .. l .. '%s' .. r .. right) -- add correct whitespace to uncomment
        n = #m
      end
      if not cs then -- first pattern is the wanted commentstring
        cs = vim.trim(left .. ' %s ' .. right) -- add correct whitespace to comment
      end
    end
  end

  return cs
end

function M.setup()
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.filetype.get_option = function(filetype, option)
    if filetype == 'comment' then
      filetype = vim.bo.filetype
    end
    if option ~= 'commentstring' then
      return M._get_option(filetype, option)
    end
    return M.get(filetype)
  end
end

return M
