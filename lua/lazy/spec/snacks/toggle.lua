local M = {}

M.virtual_text = function()
  return Snacks.toggle.new({
    id = 'virtual_text',
    name = 'Virtual Text',
    get = function()
      return vim.diagnostic.config().virtual_text ~= false
    end,
    set = function(state)
      vim.diagnostic.config({ virtual_text = state })
    end,
  })
end

M.color_column = function()
  return Snacks.toggle.new({
    id = 'color_column',
    name = 'Color Column',
    get = function()
      local cc = vim.opt_local.colorcolumn:get()
      local tw = vim.bo.textwidth
      local col = tostring(tw ~= 0 and tw or 81)
      return vim.tbl_contains(cc, col)
    end,
    set = function(state)
      local tw = vim.bo.textwidth
      local col = tostring(tw ~= 0 and tw or 81)
      vim.opt_local.colorcolumn = state and col or ''
    end,
  })
end

M.translucency = function()
  local original = vim.api.nvim_get_hl(0, { name = 'Normal', link = false })
  local saved_bg = original and original.bg

  return Snacks.toggle.new({
    id = 'translucency',
    name = 'Translucency',
    get = function()
      local bg = vim.api.nvim_get_hl(0, { name = 'Normal', link = false }).bg
      return not (bg == nil or bg == 0)
    end,
    set = function(state)
      if not state then
        vim.cmd('hi Normal guibg=none')
      else
        if saved_bg then
          vim.api.nvim_set_hl(0, 'Normal', { bg = saved_bg })
        else
          vim.cmd('hi Normal guibg=#24283B')
        end
      end
    end,
  })
end

return M
