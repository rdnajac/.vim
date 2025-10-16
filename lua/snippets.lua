--- @class Snippet
--- @field prefix string
--- @field body string
--- @field description string

-- a snippet with it's named index
--- @class nvim.Snippet : Snippet
--- @field name string

local utils = require('fileutils')

-- test
local pkg = utils.import_json(vim.fn.stdpath('config') .. '/snippets/package.json')

--- @type table<string, nvim.Snippet>
local lua = utils.import_json(vim.fn.stdpath('config') .. '/snippets/lua.json')
print(lua.autocmd.body)
vim.tbl_map(function(value)
  print(value)
end, lua.autocmd.body)

local text = [[
vim.api.nvim_create_autocmd({'${1:event}'}, {
  pattern = { '${2:*}' },
  group = aug,
  callback = function()
    ${0},
  end,
  desc = '${4}',
})
]]

print(text)

local lines = vim.tbl_map(function(line)
  return line
end, vim.split(text, '\n', { plain = true, trimempty = false }))

print(lines)
