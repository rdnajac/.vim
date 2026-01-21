local M = {}

local function picker_pair(key, opts)
  local explorer_opts = vim.deepcopy(opts)
  explorer_opts.focus = 'input'
  explorer_opts.confirm = function(p, item) p:action({ 'jump' }) end

  M[#M + 1] = { '<leader>f' .. key, function() Snacks.picker.explorer(explorer_opts) end }
  M[#M + 1] = { '<leader>s' .. key, function() Snacks.picker.grep(opts) end }
end

for k, opts in pairs({
  ['.'] = { cwd = vim.g['chezmoi#source_dir_path'], hidden = true, exclude = { '.archive' } },
  sc = { cwd = vim.fn.stdpath('cache') },
  sd = { cwd = vim.fn.stdpath('data') },
  -- R = { cwd = '~/GitHub/' },
}) do
  picker_pair(k, opts)
end

for k, opts in pairs({
  c = { cwd = vim.fn.stdpath('config') },
  p = { cwd = vim.g.plug_home },
  v = { cwd = '$VIMRUNTIME' },
  e = { dirs = vim.api.nvim_list_runtime_paths() },
}) do
  picker_pair(string.upper(k), opts) -- uppercase searches for all filetypes
  picker_pair(k, vim.tbl_extend('force', {}, opts, { ft = { 'lua', 'vim' } }))
end

return M
