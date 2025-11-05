--- @class Snippet
--- @field prefix string
--- @field body string
--- @field description string

local snippets_dir = vim.fn.stdpath('config') .. '/snippets'
local pkg = nv.file.read_json(snippets_dir .. '/package.json')

--- Load snippet files for a given filetype
--- @param filetype string The filetype to search for
--- @return table snippets Merged table of snippets from all matching files
local function load_snippets(filetype)
  local paths = {}

  -- Try simple path first: snippets/{filetype}.json
  local simple_path = snippets_dir .. '/' .. filetype .. '.json'
  if vim.fn.filereadable(simple_path) == 1 then
    table.insert(paths, simple_path)
  end

  for _, snippet in ipairs(pkg.contributes.snippets) do
    local lang = snippet.language
    local matches = false

    if type(lang) == 'string' then
      matches = lang == filetype
    elseif type(lang) == 'table' then
      matches = vim.tbl_contains(lang, filetype)
    end

    if matches and snippet.path then
      local path = snippets_dir .. '/' .. snippet.path:gsub('^%./', '')
      if not vim.tbl_contains(paths, path) then
        table.insert(paths, path)
      end
    end
  end

  local result = {}
  for _, path in ipairs(paths) do
    local snippets = nv.file.read_json(path)
    if snippets then
      result = vim.tbl_extend('force', result, snippets)
    end
  end

  return result
end

-- test
--- @type table<string, Snippet>
local lua = load_snippets('lua')
print(lua)

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

local lines = vim.split(text, '\n', { plain = true, trimempty = false })
print(lines)
