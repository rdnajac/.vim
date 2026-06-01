#!/usr/bin/env -S nvim -l
--- generate lua/nvim/meta.lua

local fs = vim.fs
local gen = require('nvim').gen

local function main()
  local lua_root = fs.joinpath(vim.fn.stdpath('config'), 'lua')
  local nvim_dir = fs.joinpath(lua_root, 'nvim')
  local meta_file = fs.joinpath(lua_root, 'meta.lua')
  local modules = {}
  local parents = {}
  local stack = { nvim_dir }
  while #stack > 0 do
    local dir = table.remove(stack)
    for name, type_ in fs.dir(dir) do
      local full = fs.joinpath(dir, name)
      if type_ == 'directory' then
        stack[#stack + 1] = full
      elseif type_ == 'file' and name:sub(-4) == '.lua' then
        local rel = full:sub(#nvim_dir + 2)
        local parts = vim.split(rel, '/', { plain = true, trimempty = true })
        local last = parts[#parts]
        if not (last == 'meta.lua' and #parts == 1) then
          if last == 'init.lua' then
            parts[#parts] = nil
          else
            parts[#parts] = last:sub(1, -5)
          end
          if #parts > 0 then
            local mod = table.concat(parts, '.')
            modules[mod] = { unpack(parts) }

            if #parts > 1 then
              local acc = {}
              for i = 1, #parts - 1 do
                acc[#acc + 1] = parts[i]
                parents[table.concat(acc, '.')] = { unpack(acc) }
              end
            end
          end
        end
      end
    end
  end

  local parent_list = vim.tbl_values(parents)
  table.sort(parent_list, function(a, b)
    if #a ~= #b then
      return #a < #b
    end
    return table.concat(a, '.') < table.concat(b, '.')
  end)

  local module_list = vim.tbl_values(modules)
  table.sort(module_list, function(a, b) return table.concat(a, '.') < table.concat(b, '.') end)

  local lines = {
    '---@meta',
    "error('this file should not be required directly')",
    '',
    'nv = nv or {}',
  }

  local function lua_path(segs)
    local out = { 'nv' }
    for _, segment in ipairs(segs) do
      if segment:match('^[%a_][%w_]*$') then
        out[#out + 1] = '.' .. segment
      else
        out[#out + 1] = string.format('[%q]', segment)
      end
    end
    return table.concat(out, '')
  end

  for _, segs in ipairs(parents) do
    local path = lua_path(segs)
    lines[#lines + 1] = string.format('%s = %s or {}', path, path)
  end

  for _, segs in ipairs(module_list) do
    lines[#lines + 1] =
      string.format("%s = require('nvim.%s')", lua_path(segs), table.concat(segs, '.'))
  end
  return gen(meta_file, lines)
end

main()
