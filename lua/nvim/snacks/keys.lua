vim.keymap.set('n', 'dI', 'dai', { desc = 'Delete Indent' })
vim.keymap.set({ 'n', 't' }, '<c-\\>', Snacks.terminal.toggle)
vim.keymap.set('v', '<leader>/', Snacks.picker.grep_word)
-- stylua: ignore start
vim.keymap.set('n', '<leader>sW', 'viW<Cmd>lua Snacks.picker.grep_word()<CR>', { desc = 'Grep <cWORD>' })
-- stylua: ignore end

local all = { hidden = true, nofile = true } -- opts for buffers (all)
local notifier = true -- whether to use the notifier window

-- stylua: ignore
local M = {
{ ',,',         function() Snacks.picker.buffers() end,     desc = 'Buffers'               },
{ '<leader>.',  function() Snacks.scratch() end,            desc = 'Toggle Scratch Buffer' },
{ '<leader>bB', function() Snacks.picker.buffers(all) end,  desc = 'Buffers (all)'         },
{ '<leader>bD', function() Snacks.bufdelete.other() end,    desc = 'Delete Other Buffers'  },
{ '<leader>bd', function() Snacks.bufdelete() end,          desc = 'Delete Buffer'         },
{ '<leader>cR', function() Snacks.rename.rename_file() end, desc = 'Rename File'           },
{ '<leader>dps', function() Snacks.profiler.scratch() end,  desc = 'Scratch profiler'      },
{ '<leader>e',  function() Snacks.explorer() end,           desc = 'File Explorer'         },
{ '<leader>fC', function() Snacks.rename.rename_file() end, desc = 'Rename File'           },
{ '<leader>gg', function() Snacks.lazygit() end,            desc = 'Lazygit' ,             },
{ '<leader>S',  function() Snacks.scratch.select() end,     desc = 'Select Scratch Buffer' },
{ '<leader>P',  function() Snacks.picker.resume({exclude={'pickers'}}) end, desc = 'Resume Picker' },
{ '<leader>un', function() Snacks.notifier.hide() end,      desc = 'Dismiss Notifications' },
{ '<leader>uz', function() Snacks.zen() end,                desc = 'Zen Mode'              },
{ '<leader>z',  function() Snacks.zen() end,                desc = 'Toggle Zen Mode'       },
{ '<leader>Z',  function() Snacks.zen.zoom() end,           desc = 'Toggle Zoom'           },
-- nvim unconditionally creates global lsp keymaps, so do it for snacks lsp keymaps too
-- { 'gai', function() Snacks.picker.lsp_incoming_calls() end, desc = 'C[a]lls Incoming' --[[has = "callHierarchy/incomingCalls"]] },
-- { 'gao', function() Snacks.picker.lsp_outgoing_calls() end, desc = 'C[a]lls Outgoing' --[[has = "callHierarchy/outgoingCalls"]] },
-- { 'grd', function() Snacks.picker.lsp_definitions() end,             desc = 'LSP Definition'        },
-- { 'grD', function() Snacks.picker.lsp_declarations() end,            desc = 'LSP Declaration'       },
-- { 'grR', function() Snacks.picker.lsp_references() end,              desc = 'LSP References'        },
-- { 'grI', function() Snacks.picker.lsp_implementations() end,         desc = 'LSP Implementation'    },
-- { 'grT', function() Snacks.picker.lsp_type_definitions() end,        desc = 'LSP Type Definition'   },
-- { '<leader>ss', function() Snacks.picker.lsp_symbols() end,          desc = 'LSP Symbols'           },
-- { '<leader>sS', function() Snacks.picker.lsp_workspace_symbols() end,desc = 'LSP Workspace Symbols' },
{ ']]', function() Snacks.words.jump(vim.v.count1) end,mode={'n','t'},desc = 'Next Reference'       },
{ '[[', function() Snacks.words.jump(-vim.v.count1)end,mode={'n','t'},desc = 'Prev Reference'       },
  {
    '<leader>N', function()
      Snacks.zen({win={file=vim.api.nvim_get_runtime_file('doc/news.txt', false)[1]}})
    end, desc = 'Neovim News'
  },
  { '<leader>n', function()
      return (notifier and Snacks.notifier.show_history or Snacks.picker.notifications)()
    end, desc = 'Notification History'
  },
}

vim.list_extend(M, {
  '<leader>dpf',
  function()
    Snacks.profiler.pick({ filter = { def_plugin = vim.fn.input('Filter by plugin: ') } })
  end,
  desc = 'Profiler Filter by Plugin',
})

---@alias LeaderLeaf string
---@alias LeaderMap table<string, LeaderLeaf|LeaderMap>

---@type LeaderMap
local leader = {
  ['/'] = 'grep',
  [','] = 'buffers',
  b = {
    b = 'buffers',
    l = 'lines',
    g = 'grep_buffers',
  },
  c = {
    d = 'diagnostics',
    D = 'diagnostics_buffer',
  },
  f = {
    b = 'buffers',
    f = 'files',
    g = 'git_files',
    P = 'projects',
    r = 'recent',
  },
  F = 'smart',
  g = {
    b = 'git_branches',
    d = 'git_diff',
    f = 'git_log_file',
    L = 'git_log_line',
    l = 'git_log',
    s = 'git_status',
    S = 'git_stash',
  },
  p = {
    P = 'picker_preview',
    a = 'picker_actions',
    f = 'picker_format',
    l = 'picker_layouts',
    p = 'pickers',
    r = 'resume',
  },
  s = {
    a = 'autocmds',
    b = 'lines',
    B = 'grep_buffers',
    C = 'commands',
    g = 'grep',
    G = 'git_grep',
    h = 'help',
    H = 'highlights',
    i = 'icons',
    j = 'jumps',
    k = 'keymaps',
    l = {
      c = 'lsp_config',
      s = 'lsp_symbols',
      S = 'lsp_workspace_symbols',
      i = 'lsp_incoming_calls',
      o = 'lsp_outgoing_calls',
      d = 'lsp_definitions',
      D = 'lsp_declarations',
      R = 'lsp_references',
      I = 'lsp_implementations',
      T = 'lsp_type_definitions',
    },
    L = 'loclist',
    m = 'marks',
    M = 'man',
    n = 'notifications',
    q = 'qflist',
    w = 'grep_word',
    u = 'undo',
    ['"'] = 'registers',
    [':'] = 'command_history',
    ['/'] = 'search_history',
  },
  u = {
    C = 'colorschemes',
  },
}

--- recursively walk the leader map and create which-key mappings
---@param tbl LeaderMap the leader map table
---@param seq? string current key sequence
local function walk(tbl, seq)
  vim.iter(tbl):each(function(k, v)
    local key = tostring(k)
    local new_seq = seq .. key
    if type(v) == 'table' then
      walk(v, new_seq)
    else
      table.insert(M, { '<leader>' .. new_seq, Snacks.picker[v], desc = v })
    end
  end)
end

walk(leader, '')

--- create a pair of file and grep pickers for a given directory or options
--- @param desc string description for which-key
--- @param key string key to use after <leader>f and <leader>s
--- @param dir_or_opts? string|table directory path or options table
--- @param picker_opts? snacks.picker.files.Config
local function picker_pair(desc, key, dir_or_opts, picker_opts)
  local opts = {}
  if type(dir_or_opts) == 'string' then
    opts = picker_opts or {}
    opts.cwd = vim.fn.expand(dir_or_opts)
  elseif type(dir_or_opts) == 'table' then
    opts = dir_or_opts
  end
  -- stylua: ignore
  return {
    { '<leader>f' .. key, function() Snacks.picker.files(opts) end, desc = desc },
    { '<leader>s' .. key, function() Snacks.picker.grep(opts) end, desc = desc },
  }
end

local picker_pairs = {
  Dotfiles = {
    '.',
    vim.g['chezmoi#source_dir_path'],
    {
      hidden = true,
      exclude = { '.archive' },
    },
  },
  DataFiles = { 'd', vim.g.stdpath.data },
  GitHubRepos = { 'G', '~/GitHub/' },
  config = { 'c', vim.fn.stdpath('config'), { ft = { 'lua', 'vim' } } },
  VIMRUNTIME = { 'v', '$VIMRUNTIME', { ft = { 'lua', 'vim' } } },
  plugins = { 'p', vim.g.plug_home, { ft = { 'lua', 'vim' } } },
  -- Plugins = { 'P', vim.g.plug_home },
  everything = { 'e', { dirs = vim.api.nvim_list_runtime_paths(), ft = { 'lua', 'vim' } } },
  Everything = { 'E', { dirs = vim.api.nvim_list_runtime_paths() } },
}

-- add the mappings to the keys table
for desc, args in pairs(picker_pairs) do
  local key, dir, opts = unpack(args)
  vim.list_extend(M, picker_pair(desc, key, dir, opts))
end

return M
