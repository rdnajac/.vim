local a = "%@v:lua.require'snacks.statuscolumn'.click_fold@  %=38   %T"
local b = "%@v:lua.require'snacks.statuscolumn'.click_fold@    %T"
local c = "%@v:lua.require'snacks.statuscolumn'.click_fold@%#DiagnosticSignHint# %*%=1   %T"

local prefix = [[%@v:lua.require'snacks.statuscolumn'.click_fold@]]

--function to escape special characters like `.` and `%`
local function escape(s)
  return s:gsub('([%%%.%+%-%*%?%[%^%$%(%)])', '%%%1')
end
local esc = [[%%@v:lua.require'snacks.statuscolumn'.click_fold@]]

local function val_or_empty(s)
  local trimmed = s and vim.trim(s) or ''
  return trimmed ~= '' and trimmed or nil
end

local function foo(s)
  local prefix = 
string.match
  if true then return s:gsub("%%@v:lua%.require'snacks%.statuscolumn'%.click_fold@(.-)%%T", '%1') end
  local matches =
    { s:match([[^%%@v:lua%.require'snacks%.statuscolumn'.click_fold@(.-)%%=(%d+)(.*)%%T$]]) }
  local count = #matches
  local left = val_or_empty(matches[1])
  local num = val_or_empty(matches[2])
  local right = val_or_empty(matches[3])
  print(
    string.format(
      '(captured %d groups: { %s, %s, %s }',
      count,
      left and ("'" .. left .. "'") or 'nil',
      num and ("'" .. num .. "'") or 'nil',
      right and ("'" .. right .. "'") or 'nil'
    )
  )
end

print(foo(a))
print(foo(b))
print(foo(c))

