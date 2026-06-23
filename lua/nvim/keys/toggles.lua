-- TODO: add toggles lsp
-- vim.lsp.codelens.enable(not vim.lsp.codelens.is_enabled())
---@type table<string, string|table|fun()>
return {
  ['yoB'] = {
    name = 'Background Translucency',
    get = function()
      return Snacks.util.is_transparent()
    end,
    set = function(state)
      local bg = Snacks.util.color('Normal', 'bg') or '#24283B'
      Snacks.util.set_hl({ Normal = { bg = state and 'none' or bg } })
      vim.api.nvim_exec_autocmds('ColorScheme', { modeline = false })
    end,
  },
  ['<leader>ut'] = Snacks.toggle.treesitter,
  ['<leader>ua'] = Snacks.toggle.animate,
  ['<leader>uw'] = Snacks.toggle.words,
  ['<leader>uv'] = {
    name = 'Virtual Text',
    get = function()
      return vim.diagnostic.config().virtual_text ~= false
    end,
    set = function(state)
      vim.diagnostic.config({ virtual_text = state })
    end,
  },
  ['yo~'] = 'autochdir',
  ['glC'] = {
    name = 'Inline Completion',
    get = function()
      return vim.lsp.inline_completion.is_enabled()
    end,
    set = function(state)
      vim.lsp.inline_completion.enable(state)
    end,
  },
  ['<leader>uD'] = Snacks.toggle.diagnostics,
  ['<leader>uH'] = Snacks.toggle.inlay_hints,
  ['<leader>uL'] = Snacks.toggle.line_number,
  ['<leader>uS'] = Snacks.toggle.scroll,
  ['<leader>uC'] = {
    name = 'Treesitter Context',
    get = function()
      return require('treesitter-context').enabled()
    end,
    set = function()
      return require('treesitter-context').toggle()
    end,
  },
  ['<leader>dpp'] = Snacks.toggle.profiler,
  ['<leader>dph'] = Snacks.toggle.profiler_highlights,
}
