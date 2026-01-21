local M = {}

local function picker_pair(key, opts)
  local explorer_opts = vim.deepcopy(opts)
  explorer_opts.focus = 'input'
  explorer_opts.confirm = function(p, item) p:action({ 'jump' }) end

  return {
    { '<leader>f' .. key, function() Snacks.picker.explorer(explorer_opts) end },
    -- { '<leader>f' .. key, function() Snacks.picker.files(opts) end },
    { '<leader>s' .. key, function() Snacks.picker.grep(opts) end },
  }
end

-- TODO: incorperate `cd`
-- { 'c', vim.fn.stdpath('config') },
-- { 'C', vim.fn.stdpath('cache') },
-- { 'D', vim.fn.stdpath('data') },


for k, opts in pairs({
  ['.'] = { cwd = vim.g['chezmoi#source_dir_path'], hidden = true, exclude = { '.archive' } },
  -- R = { cwd = '~/GitHub/' },
  c = { cwd = vim.fn.stdpath('config'), { ft = { 'lua', 'vim' } } },
  C = { cwd = vim.fn.stdpath('config'), { ft = { 'lua', 'vim' } } },
  p = { cwd = vim.g.plug_home, ft = { 'lua', 'vim' } },
  P = { cwd = vim.g.plug_home, ft = { 'lua', 'vim' } },
  v = { cwd = '$VIMRUNTIME', ft = { 'lua', 'vim' } },
  V = { cwd = '$VIMRUNTIME' },
  e = { dirs = vim.api.nvim_list_runtime_paths(), ft = { 'lua', 'vim' } },
  E = { dirs = vim.api.nvim_list_runtime_paths() },
}) do
  vim.list_extend(M, picker_pair(k, opts))
end

return M
