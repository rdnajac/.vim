#!/usr/bin/env -S nvim -l
--- generate snippets/package.json

local fs = vim.fs
local file = require('nvim.util.file')

local function normalize_path(path)
  return path:gsub('^%./', '')
end

local function read_existing_languages(path)
  local ok, decoded = pcall(function()
    local contents = table.concat(vim.fn.readfile(path), '\n')
    return vim.json.decode(contents)
  end)
  if not ok or type(decoded) ~= 'table' then
    return {}
  end

  local contributes = decoded.contributes or {}
  local snippets = contributes.snippets or {}
  local map = {}
  for _, item in ipairs(snippets) do
    if item.path and item.language then
      map[normalize_path(item.path)] = item.language
    end
  end
  return map
end

local function list_snippet_files(root)
  local files = {}
  local stack = { root }
  while #stack > 0 do
    local dir = table.remove(stack)
    for name, type_ in fs.dir(dir) do
      local full = fs.joinpath(dir, name)
      if type_ == 'directory' then
        stack[#stack + 1] = full
      elseif type_ == 'file' and name:sub(-5) == '.json' and name ~= 'package.json' then
        files[#files + 1] = full
      end
    end
  end
  table.sort(files)
  return files
end

local function language_for_file(rel, lang_map)
  local language = lang_map[rel]
  if language ~= nil then
    return language
  end
  return rel:match('([^/]+)%.json$')
end

local function script_root()
  local source = debug.getinfo(1, 'S').source
  if source:sub(1, 1) == '@' then
    return fs.dirname(source:sub(2))
  end
  return vim.fn.getcwd()
end

local function main()
  local config_root = fs.dirname(script_root())
  local snippets_root = fs.joinpath(config_root, 'snippets')
  local package_file = fs.joinpath(snippets_root, 'package.json')
  local lang_map = read_existing_languages(package_file)
  local files = list_snippet_files(snippets_root)

  local rels = {}
  for _, full in ipairs(files) do
    rels[#rels + 1] = full:sub(#snippets_root + 2)
  end

  local snippet_entries = {}
  for _, rel in ipairs(rels) do
    local language = language_for_file(rel, lang_map)
    snippet_entries[#snippet_entries + 1] = {
      language = language,
      path = './' .. rel,
    }
  end

  local payload = {
    name = 'my-snippets',
    contributes = {
      snippets = snippet_entries,
    },
  }
  local stringified = vim.json.encode(payload, { indent = '  ' })
  local lines = vim.split(stringified, '\n', { plain = true })

  file.gen(package_file, lines)
end

main()
