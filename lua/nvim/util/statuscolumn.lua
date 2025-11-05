-- nv.patch = function(mod, fun)
--   package.preload[mod] = function()
--     local mp = mod:gsub('%.', '/')
--     local path = vim.api.nvim_get_runtime_file('lua/' .. mp .. '.lua', false)[1]
--       or vim.api.nvim_get_runtime_file('lua/' .. mp .. '/init.lua', false)[1]
--     if not path then
--       error('Module ' .. mod .. ' not found')
--     end
--     local loader, err = loadfile(path)
--     if not loader then
--       error(err)
--     end
--     local orig = loader()
--     fun(orig)
--     return orig
--   end
-- end
-- ~/.local/share/nvim/site/pack/core/opt/snacks.nvim/lua/snacks/statuscolumn.lua
nv.patch('snacks.statuscolumn', function(M)
  local orig_get = M._get

  M._get = function()
    local win = vim.g.statusline_winid
    local nu = vim.wo[win].number
    local rnu = vim.wo[win].relativenumber
    local show_signs = vim.v.virtnum == 0 and vim.wo[win].signcolumn ~= 'no'
    local show_folds = vim.v.virtnum == 0 and vim.wo[win].foldcolumn ~= '0'
    local buf = vim.api.nvim_win_get_buf(win)
    local config = require('snacks').config.get('statuscolumn')
    local left_c = type(config.left) == 'function' and config.left(win, buf, vim.v.lnum)
      or config.left
    local right_c = type(config.right) == 'function' and config.right(win, buf, vim.v.lnum)
      or config.right

    local wanted = { sign = show_signs }
    for _, c in ipairs(left_c) do
      wanted[c] = wanted[c] ~= false
    end
    for _, c in ipairs(right_c) do
      wanted[c] = wanted[c] ~= false
    end

    local components = { '', '', '' } -- left, middle, right

    -- Always maintain column width
    local has_mark = false
    local mark_text = nil

    if (nu or rnu) and vim.v.virtnum == 0 then
      -- Check for marks first
      local signs = M.line_signs(win, buf, vim.v.lnum, wanted)
      for _, s in ipairs(signs) do
        if s.type == 'mark' then
          has_mark = true
          mark_text = s.text
          break
        end
      end

      if has_mark then
        -- Show mark instead of line number
        components[2] = '%=' .. mark_text .. ' '
      else
        local num
        if rnu and nu and vim.v.relnum == 0 then
          num = vim.v.lnum
        elseif rnu then
          num = vim.v.relnum
        else
          num = vim.v.lnum
        end
        components[2] = '%=' .. num .. ' '
      end
    else
      -- Keep consistent width even without numbers
      components[2] = '  '
    end

    if show_signs or show_folds then
      local signs = M.line_signs(win, buf, vim.v.lnum, wanted)

      if #signs > 0 then
        local signs_by_type = {}
        for _, s in ipairs(signs) do
          signs_by_type[s.type] = signs_by_type[s.type] or s
        end

        local function find(types)
          for _, t in ipairs(types) do
            if signs_by_type[t] then
              return signs_by_type[t]
            end
          end
        end

        local left, right = find(left_c), find(right_c)

        if config.folds.git_hl then
          local git = signs_by_type.git
          if git and left and left.type == 'fold' then
            left.texthl = git.texthl
          end
          if git and right and right.type == 'fold' then
            right.texthl = git.texthl
          end
        end
        components[1] = left and M.icon(left) or '  '
        components[3] = right and M.icon(right) or '  '
      else
        components[1] = '  '
        components[3] = '  '
      end
    else
      components[1] = '  '
      components[3] = '  '
    end

    components[1] = vim.b[buf].snacks_statuscolumn_left ~= false and components[1] or ''
    components[3] = vim.b[buf].snacks_statuscolumn_right ~= false and components[3] or ''

    local ret = table.concat(components, '')
    -- Remove click fold wrapper
    return ret
  end
end)
