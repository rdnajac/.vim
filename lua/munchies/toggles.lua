---@type table<string, table|string|fun():snacks.toggle.Class|snacks.toggle.Opts>
return {
  ['<leader>ac'] = 'autochdir',
  ['<leader>dpp'] = Snacks.toggle.profiler,
  ['<leader>dph'] = Snacks.toggle.profiler_highlights,
  ['<leader>ua'] = Snacks.toggle.animate,
  ['<leader>ud'] = Snacks.toggle.diagnostics,
  ['<leader>uD'] = Snacks.toggle.dim,
  ['<leader>ug'] = Snacks.toggle.indent,
  ['<leader>uh'] = Snacks.toggle.inlay_hints,
  ['<leader>ul'] = Snacks.toggle.line_number,
  ['<leader>uS'] = Snacks.toggle.scroll,
  ['<leader>ut'] = Snacks.toggle.treesitter,
  ['<leader>uW'] = Snacks.toggle.words,
  ['<leader>uZ'] = Snacks.toggle.zoom,
  ['<leader>us'] = 'spell',
  ['<leader>uL'] = 'relativenumber',
  ['<leader>uw'] = 'wrap',
  ['<leader>uv'] = {
    name = 'Virtual Text',
    get = function() return vim.diagnostic.config().virtual_text ~= false end,
    set = function(state) vim.diagnostic.config({ virtual_text = state }) end,
  },
  ['<leader>ub'] = {
    name = 'Translucency',
    get = Snacks.util.is_transparent,
    set = function(state)
      local bg = Snacks.util.color('Normal', 'bg') or '#24283B'
      Snacks.util.set_hl({ Normal = { bg = state and 'none' or bg } })
      vim.api.nvim_exec_autocmds('ColorScheme', { modeline = false })
    end,
  },
  ['<leader>uu'] = {
    name = 'LastStatus',
    get = function() return vim.o.laststatus > 0 end,
    set = function(state)
      if not state then
        vim.w.lastlaststatus = vim.o.laststatus
        vim.o.laststatus = 0
      else
        vim.o.laststatus = vim.w.lastlaststatus or 2
      end
    end,
  },
  ['<leader>u\\'] = {
    name = 'ColorColumn',
    get = function()
      ---@diagnostic disable-next-line: undefined-field
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
  },
}
-- vim: fdl=1
