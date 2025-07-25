local M = {}

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

M.winborder = function()
  local saved = nil

  return Snacks.toggle.new({
    id = 'winborder',
    name = 'Window Border',
    get = function()
      return vim.o.winborder ~= '' and vim.o.winborder ~= 'none'
    end,
    set = function(state)
      if not state then
        saved = saved or vim.o.winborder
        vim.o.winborder = 'none'
      else
        vim.o.winborder = saved or 'rounded'
      end
    end,
  })
end

M.laststatus = function()
  return Snacks.toggle.new({
    id = 'laststatus',
    name = 'Laststatus',
    get = function()
      return vim.o.laststatus > 0
    end,
    set = function(state)
      if not state then
        vim.b.lastlaststatus = vim.o.laststatus
        vim.o.laststatus = 0
      else
        vim.o.laststatus = vim.b.lastlaststatus or 2
      end
    end,
  })
end

M.setup = function()
  Snacks.toggle.profiler():map('<leader>dpp')
  Snacks.toggle.profiler_highlights():map('<leader>dph')
  Snacks.toggle.animate():map('<leader>ua')
  Snacks.toggle.diagnostics():map('<leader>ud')
  Snacks.toggle.dim():map('<leader>uD')
  Snacks.toggle.treesitter():map('<leader>ut')
  Snacks.toggle.indent():map('<leader>ug')
  Snacks.toggle.scroll():map('<leader>us')
  Snacks.toggle.words():map('<leader>uw')
  Snacks.toggle.zoom():map('<leader>uZ')

  M.translucency():map('<leader>ub', { desc = 'Toggle Translucent Background' })
  M.virtual_text():map('<leader>uv', { desc = 'Toggle Virtual Text' })
  M.color_column():map('<leader>u\\', { desc = 'Toggle Color Column' })
  M.winborder():map('<leader>uW', { desc = 'Toggle Window Border' })
  M.laststatus():map('<leader>ul', { desc = 'Toggle Laststatus' })
end

M.setup()

return M

-- -- TODO: move to vimline
-- vim.api.nvim_create_autocmd('CmdlineEnter', {
--   group = aug,
--   callback = function()
--     vim.b.lastlaststatus = vim.o.laststatus
--     vim.o.laststatus = 0
--   end,
-- })
--
-- vim.api.nvim_create_autocmd('CmdlineLeave', {
--   group = aug,
--   callback = function()
--     vim.o.laststatus = vim.b.lastlaststatus or 2
--   end,
-- })
