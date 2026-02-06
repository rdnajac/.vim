-- overrides: $PACKDIR/dial.nvim/lua/dial/config.lua
-- local config = require('dial.config')
-- config.augends:register_group(defaults)
-- config.augends:on_filetype(fts)
local augend = require('dial.augend')
local user = require('dial.augend.user')

---@param elements string[] The elements to cycle through
---@param word? boolean Whether the elements are words (true) or symbols (false). Default: false
---@param cyclic? boolean Whether the cycle is cyclic (true) or not (false). Default: true
---@return Augend
local new = function(elements, word, cyclic)
  return augend.constant.new({
    elements = elements,
    word = word ~= true,
    cyclic = cyclic ~= false,
  })
end

local M = {
  augends = {
    group = {
      default = {
        augend.integer.alias.decimal_int,
        augend.integer.alias.decimal,
        augend.integer.alias.hex,
        augend.date.new({ pattern = '%Y/%m/%d', default_kind = 'day' }),
        augend.date.new({ pattern = '%Y-%m-%d', default_kind = 'day' }),
        augend.date.new({ pattern = '%m/%d', default_kind = 'day', only_valid = true }),
        augend.date.new({ pattern = '%H:%M', default_kind = 'day', only_valid = true }),
        augend.constant.alias.en_weekday,
        augend.constant.alias.en_weekday_full,
        augend.constant.alias.bool,
        augend.constant.alias.Bool,
        -- new({ 'and', 'or' }, true),
        new({ '&&', '||' }),
        new({ 'top', 'middle', 'bottom' }, true),
        new({ 'left', 'center', 'right' }, true),
        new({ 'start', 'end' }, true),
        new({ 'row', 'col' }),
        new({ 'human', 'mouse' }),
        -- stylua: ignore start
        new({ 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec' }, true),
        new({ 'January', 'February', 'March', 'April', 'May', 'June', 'July',
	      'August', 'September', 'October', 'November', 'December' }, true),
        new({ 'first', 'second', 'third', 'fourth', 'fifth', 'sixth', 'seventh',
	      'eighth', 'ninth', 'tenth', 'eleventh', 'twelfth', 'thirteenth' }),
        -- stylua: ignore end
      },
    },
  },
}

local filetype = {
  css = {
    augend.hexcolor.new({ case = 'lower' }),
    augend.hexcolor.new({ case = 'upper' }),
  },
  json = { augend.semver.alias.semver },
  markdown = { augend.misc.alias.markdown_header },
  lua = {
    new({ '_a', '_a', '_c', '_x', '_y', '_z' }, true),
    user.new({
      ---@param line string
      ---@param cursor? integer
      ---@return textrange?
      find = function(line, cursor)
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
      end,

      ---@param text string
      ---@param addend integer
      ---@param cursor? integer
      ---@return { text?: string, cursor?: integer }
      add = function(text, addend, cursor)
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
        local new_text =
          string.format('require(%s%s%s)', quote, table.concat(require_parts, '.'), quote)

        for i = split_pos + 1, #all_parts do
          new_text = new_text .. '.' .. all_parts[i]
        end

        return { text = new_text, cursor = cursor }
      end,
    }),
  },
  r = {
    new({ 'TRUE', 'FALSE' }),
  },
  sh = {
    new({ 'bash', 'sh', 'zsh' }),
  },
  vim = {
    new({ 'echom', 'execute' }),
  },
  -- filetype mappings
  quarto = 'rmd',
  sass = 'css',
  scss = 'css',
  zsh = 'sh',
}

-- combine filetypes
filetype.rmd = vim.tbl_extend('force', {}, filetype.markdown, filetype.r)

M.augends.filetype = setmetatable({}, {
  __index = function(t, ft)
    local v = rawget(filetype, ft)
    local res

    if type(v) == 'string' then
      -- only follow one level of redirection
      if type(rawget(filetype, v)) == 'string' then
        error(('too many levels of redirection: %s = %s'):format(ft, v))
      end
      res = t[v] -- redirect and re-trigger __index
    elseif type(v) == 'table' then
      -- create a copy and extend with defaults on first access
      res = vim.list_extend(vim.deepcopy(v), M.augends.group.default)
    end

    rawset(t, ft, res)
    return res
  end,
})

local SELECT = [[lua require('dial.command').select_cugend_%s(%s)]]
local TXTOBJ = [[lua require('dial.command').textobj()]]
local OPFUNC = [[let &opfunc='dial#operator#%s_%s']]
-- calls: lua require("dial.command").operator_%s("decrement", true)

local function cmdcr(s) return string.format('<Cmd>%s<CR>', s) end
-- local function cmdcr(s) return return '<Cmd>' .. s .. '<CR>' end
local visual_modes = { v = true, V = true, ['\22'] = true }
local is_visual = function() return visual_modes[vim.fn.mode(true)] end

---@diagnostic disable-next-line: unused-function
local function dial(increment, g)
  local mode = (g and 'g' or '') .. (is_visual() and 'visual' or 'normal')
  local direction = increment and 'increment' or 'decrement'
  local select = string.format(SELECT, mode, group)
  local setop = string.format(OPFUNC, direction, mode)
  local textobj = (mode == 'normal' or mode == 'gnormal') and TXTOBJ or ''
  local cmd = vim.v.count1 .. cmdcr(select) .. cmdcr(setop) .. 'g@' .. cmdcr(textobj)
  local keys = vim.keycode(cmd)
  vim.cmd.normal({ keys, bang = true })
  -- vim.api.nvim_feedkeys(keys, 'n', false)
end

return M
