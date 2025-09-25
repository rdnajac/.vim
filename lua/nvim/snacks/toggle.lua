local M = {}

Snacks.toggle.profiler():map('<leader>dpp')
Snacks.toggle.profiler_highlights():map('<leader>dph')
Snacks.toggle.animate():map('<leader>ua')
Snacks.toggle.diagnostics():map('<leader>ud')
Snacks.toggle.dim():map('<leader>uD')
Snacks.toggle.indent():map('<leader>ug')
Snacks.toggle.scroll():map('<leader>uS')
Snacks.toggle.words():map('<leader>uW')
Snacks.toggle.zoom():map('<leader>uZ')

Snacks.toggle.treesitter():map('<leader>ut')

Snacks.toggle.option('wrap', { name = 'Wrap' }):map('<leader>uw')
Snacks.toggle.option('spell', { name = 'Spelling' }):map('<leader>us')
Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map('<leader>uL')
Snacks.toggle.line_number():map('<leader>ul')

-- if client:supports_method('textDocument/inlayHint') then
Snacks.toggle.inlay_hints():map('<leader>uh')

-- TODO: toggle copilot
-- TODO: toggle vim.lsp.inline_completion

---@param opts? snacks.toggle.Config
M.colorcolumn = function(opts)
  return Snacks.toggle({
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
  return Snacks.toggle({
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

M.laststatus = function()
  return Snacks.toggle({
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
  })
end

---Create a toggleable Vim variable
---@param opts table
---   name string: variable name without prefix
---   default boolean|number: default value (0/1 or false/true)
---   scope string?: optional scope ('g', 'b', 'w', etc.), default 'g'
---   mapping string?: optional key mapping
---   desc string?: optional description for the mapping
---@return table toggle object
M.flag = function(opts)
  local name = opts.name
  local default = opts.default or 1
  local scope = opts.scope or 'g'
  local mapping = opts.mapping
  local desc = opts.desc or ('Toggle ' .. name)

  vim[scope][name] = vim[scope][name] ~= nil and vim[scope][name] or default

  local toggle = Snacks.toggle({
    name = opts.label or name:gsub('_', ' '):gsub('^%l', string.upper),
    get = function()
      local val = vim[scope][name]
      return val == '1' or val == 1 or val == true
    end,
    set = function(state)
      vim[scope][name] = state and 1 or 0
    end,
  })
  if mapping then
    toggle:map(mapping, { desc = desc })
  end
  return toggle
end

M.colorcolumn():map('<leader>u\\', { desc = 'Toggle ColorColumn' })
M.virtual_text():map('<leader>uv', { desc = 'Toggle Virtual Text' })
M.laststatus():map('<leader>uu', { desc = 'Toggle LastStatus' })
if package.loaded['render-markdown'] then
  local m = require('render-markdown')
  Snacks.toggle({
    name = 'Render Markdown',
    get = function()
      return require('render-markdown.state').enabled
    end,
    set = function(enabled)
      m.set(enabled)
    end,
  }):map('<leader>um')
end

return M
