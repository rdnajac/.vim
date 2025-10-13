Snacks.toggle.animate():map('<leader>ua')
Snacks.toggle.diagnostics():map('<leader>ud')
Snacks.toggle.dim():map('<leader>uD')
Snacks.toggle.indent():map('<leader>ug')
Snacks.toggle.inlay_hints():map('<leader>uh')
Snacks.toggle.line_number():map('<leader>ul')
Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map('<leader>uL')
Snacks.toggle.option('spell', { name = 'Spelling' }):map('<leader>us')
Snacks.toggle.option('wrap', { name = 'Wrap' }):map('<leader>uw')
Snacks.toggle.profiler():map('<leader>dpp')
Snacks.toggle.profiler_highlights():map('<leader>dph')
Snacks.toggle.scroll():map('<leader>uS')
Snacks.toggle.treesitter():map('<leader>ut')
Snacks.toggle.words():map('<leader>uW')
Snacks.toggle.zoom():map('<leader>uZ')

---@type { string: snacks.toggle.Opts }[]
local toggles = {
  ['<leader>u\\'] = {
    id = 'colorcolumn',
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
  ['<leader>uv'] = {
    id = 'virtual_text',
    name = 'Virtual Text',
    get = function()
      return vim.diagnostic.config().virtual_text ~= false
    end,
    set = function(state)
      vim.diagnostic.config({ virtual_text = state })
    end,
  },
  ['<leader>ub'] = {
    id = 'translucency',
    name = 'Translucency',
    get = Snacks.util.is_transparent,
    set = function(state)
      local bg = Snacks.util.color('Normal', 'bg') or '#24283B'
      Snacks.util.set_hl({ Normal = { bg = state and 'none' or bg } })
      vim.api.nvim_exec_autocmds('ColorScheme', { modeline = false })
    end,
  },
  ['<leader>uu'] = {
    id = 'laststatus',
    name = 'LastStatus',
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
  },
}

--- @param lhs string
--- @param opts? snacks.toggle.Opts
local function toggle(lhs, opts)
  Snacks.toggle.new(opts):map(lhs)
end

---@type { [string]: snacks.toggle.Opts }[]
local toggles = {
  ['<leader>u\\'] = {
    id = 'colorcolumn',
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
  ['<leader>uv'] = {
    id = 'virtual_text',
    name = 'Virtual Text',
    get = function()
      return vim.diagnostic.config().virtual_text ~= false
    end,
    set = function(state)
      vim.diagnostic.config({ virtual_text = state })
    end,
  },
  ['<leader>ub'] = {
    id = 'translucency',
    name = 'Translucency',
    get = Snacks.util.is_transparent,
    set = function(state)
      local bg = Snacks.util.color('Normal', 'bg') or '#24283B'
      Snacks.util.set_hl({ Normal = { bg = state and 'none' or bg } })
      vim.api.nvim_exec_autocmds('ColorScheme', { modeline = false })
    end,
  },
  ['<leader>uu'] = {
    id = 'laststatus',
    name = 'LastStatus',
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
  },
}

for k, v in pairs(toggles) do
  Snacks.toggle.new(v):map(k)
end
