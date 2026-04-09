-- local augend = require('dial.augend')
-- local augends = {
--   augend.integer.alias.decimal_int,
--   augend.integer.alias.decimal,
--   augend.integer.alias.hex,
--   augend.hexcolor.new({ case = 'lower' }),
--   augend.hexcolor.new({ case = 'upper' }),
--   augend.semver.alias.semver,
-- }

local find = function(line, cursor)
  local start_pos = line:find('require%s*%(%s*[\'"]')
  if not start_pos then
    return nil
  end

  local quote_pos = line:find('[\'"]', start_pos + 7)
  if not quote_pos then
    return nil
  end

  local end_quote = line:find('[\'"]', quote_pos + 1)
  if not end_quote then
    return nil
  end

  local end_pos = end_quote + 1
  local paren_end = line:find('%)', end_pos)
  if paren_end then
    end_pos = paren_end
    local trailing = line:match('^%.%w+', end_pos + 1)
    if trailing then
      end_pos = end_pos + #trailing
    end
  end

  return { from = start_pos, to = end_pos }
end

---@param text string
---@param addend integer
---@param cursor? integer
---@return { text?: string, cursor?: integer }
local add = function(text, addend, cursor)
  local quote = text:match('require%s*%(%s*([\'"])')
  local module_path = text:match('require%s*%(%s*[\'"]([^\'"]+)[\'"]')
  local trailing = text:match('%)(.*)$') or ''

  if not module_path or not quote then
    return { text = text, cursor = cursor }
  end

  local parts = vim.split(module_path, '.', { plain = true })
  local trail_parts = {}
  for part in trailing:gmatch('%.(%w+)') do
    table.insert(trail_parts, part)
  end

  local all_parts = vim.list_extend(vim.list_slice(parts), trail_parts)
  if #all_parts == 0 then
    return { text = text, cursor = cursor }
  end

  local split_pos = math.max(1, math.min(#parts + addend, #all_parts))
  local require_parts = vim.list_slice(all_parts, 1, split_pos)
  local new_text = string.format('require(%s%s%s)', quote, table.concat(require_parts, '.'), quote)

  for i = split_pos + 1, #all_parts do
    new_text = new_text .. '.' .. all_parts[i]
  end

  return { text = new_text, cursor = cursor }
end
