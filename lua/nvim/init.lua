_G.nv = require('nvim.util')

nv.plugins = require('nvim.plugins')

local root = 'nvim'
local dir = nv.stdpath.config .. '/lua/' .. root
local mods = {}

-- top-level .lua files
for _, f in ipairs(vim.fn.globpath(dir, '*.lua', false, true)) do
  local name = f:match('([^/]+)%.lua$')
  if name and name ~= 'init' then
    mods[name] = true
  end
end

-- one level of subdirs
for _, d in ipairs(vim.fn.globpath(dir, '*/', false, true)) do
  local subname = d:match('([^/]+)/$')
  if subname then
    local submods = {}
    for _, f in ipairs(vim.fn.globpath(d, '*.lua', false, true)) do
      local child = f:match('([^/]+)%.lua$')
      if child and child ~= 'init' then
        submods[child] = true
      end
    end
    if next(submods) then
      mods[subname] = submods
    else
      mods[subname] = true
    end
  end
end

-- dd(mods)
-- _G.nv = vim._defer_require('nvim', mods)
