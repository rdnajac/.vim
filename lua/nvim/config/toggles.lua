if not Snacks then
  vim.cmd([[Warn "'skipping toggles'"]])
  return
end
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

-- additional option toggles
local options = {
  autochdir = '<leader>ac',
}

for opt, key in pairs(options) do
  Snacks.toggle.option(opt):map(key)
end

---@type table<string, snacks.toggle.Opts>
local toggles = {
  ['<leader>ai'] = {
    name = 'Inline Completion',
    get = function()
      return vim.lsp.inline_completion.is_enabled()
    end,
    set = function(state)
      vim.lsp.inline_completion.enable(state)
    end,
  },
  ['<leader>uv'] = {
    name = 'Virtual Text',
    get = function()
      return vim.diagnostic.config().virtual_text ~= false
    end,
    set = function(state)
      vim.diagnostic.config({ virtual_text = state })
    end,
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

if package.loaded['render-markdown'] then
  toggles['<leader>um'] = {
    name = 'Render Markdown',
    get = function()
      return require('render-markdown.state').enabled
    end,
    set = function(state)
      require('render-markdown').set(state)
    end,
  }
end

-- if MiniDiff ~= nil then
toggles['<leader>uG'] = {
  name = 'MiniDiff Signs',
  get = function()
    return vim.g.minidiff_disable ~= true
  end,
  set = function(state)
    vim.g.minidiff_disable = not state
    MiniDiff.toggle(0)
    nv.fn.defer_redraw()
  end,
}

toggles['<leader>go'] = {
  name = 'MiniDiff Overlay',
  get = function()
    local data = MiniDiff.get_buf_data(0)
    return data and data.overlay == true or false
  end,
  set = function(_)
    MiniDiff.toggle_overlay(0)
    nv.fn.defer_redraw()
  end,
}
-- end

if package.loaded['treesitter-context'] then
  local tsc = require('treesitter-context')
  toggles['<leader>ux'] = {
    name = 'Treesitter Context',
    get = tsc.enabled,
    set = tsc.toggle,
  }
end

if package.loaded['sidekick'] then
  toggles['<leader>uN'] = {
    name = 'Sidekick NES',
    get = function()
      return require('sidekick.nes').enabled
    end,
    set = function(state)
      require('sidekick.nes').enable(state)
    end,
  }
end

-- TODO: extui

for key, opts in pairs(toggles) do
  Snacks.toggle.new(opts):map(key)
end
-- vim: fdl=1
