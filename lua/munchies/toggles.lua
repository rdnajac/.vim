---@type table<string, string|table|fun()>
return {
  -- nnoremap yo~ :<C-u>set acd!<BAR>set acd?<CR>
  ['yo~'] = 'autochdir',
  ['yoa'] = Snacks.toggle.animate,
  --*yob*	'background' (dark is off, light is on)
  ['yoB'] = {
    name = 'Background Translucency',
    get = function() return Snacks.util.is_transparent() end,
    set = function(state)
      local bg = Snacks.util.color('Normal', 'bg') or '#24283B'
      Snacks.util.set_hl({ Normal = { bg = state and 'none' or bg } })
      vim.api.nvim_exec_autocmds('ColorScheme', { modeline = false })
    end,
  },
  --*yoc*	'cursorline'
  ['yoC'] = {
    name = 'Inline Completion',
    get = function() return vim.lsp.inline_completion.is_enabled() end,
    set = function(state) vim.lsp.inline_completion.enable(state) end,
  },
  --*yod*	'diff' (actually |:diffthis| / |:diffoff|)
  ['yoD'] = Snacks.toggle.diagnostics,
  --*yoh*	'hlsearch'
  ['yoH'] = Snacks.toggle.inlay_hints,
  --*yoi*	'ignorecase'
  ['yoI'] = 'indent',
  --*yol*	'list'
  ['yoL'] = Snacks.toggle.line_number,
  --*yon*	'number'
  --*yor*	'relativenumber'
  ['yor'] = 'relativenumber',
  --*yos*	'spell'
  ['yos'] = 'spell',
  ['yoS'] = Snacks.toggle.scroll,
  --*yot*	'colorcolumn' ("+1" or last used value)
  ['yoT'] = {
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
  ['yot'] = Snacks.toggle.treesitter,
  --*you*	'cursorcolumn'
  --*yov*	'virtualedit'
  --*yow*	'wrap'
  ['yow'] = 'wrap',
  ['yoW'] = Snacks.toggle.words,
  --*yox*	'cursorline' 'cursorcolumn' (x as in crosshairs)
  ['yoz'] = Snacks.toggle.zen,
  ['yoZ'] = Snacks.toggle.zoom,
  ['<leader>dpp'] = Snacks.toggle.profiler,
  ['<leader>dph'] = Snacks.toggle.profiler_highlights,
  ['<leader>ud'] = Snacks.toggle.dim,
  ['<leader>uv'] = {
    name = 'Virtual Text',
    get = function() return vim.diagnostic.config().virtual_text ~= false end,
    set = function(state) vim.diagnostic.config({ virtual_text = state }) end,
  },
}
