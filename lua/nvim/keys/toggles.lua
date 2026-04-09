--Toggle	Option
--*yob*	'background' (dark is off, light is on)
--*yoc*	'cursorline'
--*yod*	'diff' (actually |:diffthis| / |:diffoff|)
--*yoh*	'hlsearch'
--*yoi*	'ignorecase'
--*yol*	'list'
--*yon*	'number'
--*yor*	'relativenumber'
--*yos*	'spell'
--*yot*	'colorcolumn' ("+1" or last used value)
--*you*	'cursorcolumn'
--*yov*	'virtualedit'
--*yow*	'wrap'
--*yox*	'cursorline' 'cursorcolumn' (x as in crosshairs)

---@type table<string, string|snacks.toggle.Opts>
-- TODO: change to 'yo'
return {
  ['<leader>ac'] = 'autochdir',
  ['<leader>dpp'] = 'profiler',
  ['<leader>dph'] = 'profiler_highlights',
  ['<leader>ua'] = 'animate',
  ['<leader>ud'] = 'diagnostics',
  ['<leader>uD'] = 'dim',
  ['<leader>ug'] = 'indent',
  ['<leader>uh'] = 'inlay_hints',
  ['<leader>ul'] = 'line_number',
  ['<leader>uS'] = 'scroll',
  ['<leader>ut'] = 'treesitter',
  ['<leader>uW'] = 'words',
  ['<leader>uZ'] = 'zoom',
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
    get = function() return Snacks.util.is_transparent() end,
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
  ['<leader>ai'] = {
    name = 'Inline Completion',
    get = function() return vim.lsp.inline_completion.is_enabled() end,
    set = function(state) vim.lsp.inline_completion.enable(state) end,
  },
}
