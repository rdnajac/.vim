---@alias LeaderLeaf string|function
---@alias LeaderMap table<string, LeaderLeaf|LeaderMap>

---@type LeaderMap
local leader = {
  ['.'] = Snacks.scratch,
  ['/'] = Snacks.picker.grep,
  [','] = Snacks.picker.buffers,
  b = {
    -- 'buffers',
    b = 'buffers',
    B = function() Snacks.picker.buffers({ hidden = true, nofile = true }) end,
    D = Snacks.bufdelete.other,
    d = Snacks.bufdelete,
    l = 'lines',
    g = 'grep_buffers',
  },
  c = {
    -- 'coding',
    d = 'diagnostics',
    D = 'diagnostics_buffer',
    R = Snacks.rename.rename_file,
  },
  d = {
    p = {
      f = {
        function()
          Snacks.profiler.pick({ filter = { def_plugin = vim.fn.input('Filter by plugin: ') } })
        end,
      },
      s = Snacks.profiler.scratch,
    },
  },
  e = Snacks.explorer,
  F = 'smart',
  f = {
    b = 'buffers',
    f = 'files',
    g = 'git_files',
    P = 'projects',
    r = 'recent',
    C = Snacks.rename.rename_file,
  },
  g = {
    b = 'git_branches',
    d = 'git_diff',
    f = 'git_log_file',
    g = Snacks.lazygit,
    L = 'git_log_line',
    l = 'git_log',
    s = 'git_status',
    S = 'git_stash',
  },
  N = {
    function()
      Snacks.zen({ win = { file = vim.api.nvim_get_runtime_file('doc/news.txt', false)[1] } })
    end,
  },
  n = Snacks.notifier.show_history,
  P = function() Snacks.picker.resume({ exclude = { 'pickers' } }) end,
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
      'lsp',
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
    W = 'viW<Cmd>lua Snacks.picker.grep_word()<CR>',
    u = 'undo',
    ['"'] = 'registers',
    [':'] = 'command_history',
    ['/'] = 'search_history',
  },
  S = Snacks.scratch.select,
  u = {
    C = 'colorschemes',
    n = Snacks.notifier.hide,
    z = Snacks.zen,
  },
  z = Snacks.zen --[[@as fun()]],
  Z = Snacks.zen.zoom,
}

--- recursively walk the leader map and create which-key mappings
---@param tbl LeaderMap the leader map table
---@param seq? string current key sequence
local function walk(tbl, seq)
  return vim.iter(tbl):fold({}, function(acc, k, v)
    local key = seq .. tostring(k)
    local rhs, desc
    if type(v) == 'string' then
      if Snacks.picker[v] ~= nil then
        rhs = Snacks.picker[v]
        desc = v:gsub('_', ' ')
      else
        rhs = v
        desc = v
      end
    elseif type(v) == 'function' then
      rhs = v
      desc = key
    elseif type(v) == 'table' then
      if vim.is_callable(v) then
        rhs = function(...) return v(...) end
        desc = key
      else
        return vim.list_extend(acc, walk(v, key))
      end
    end
    if rhs then
      table.insert(acc, { '<leader>' .. key, rhs, desc = desc })
    end
    return acc
  end)
end

local M = walk(leader, '')

return M
