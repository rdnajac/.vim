-- TODO: function for fetching icon based on where the plugin was defined and whether it was vim or lua
-- TODO: do the same for descriptions of cmd mappings
-- TODO: find missing descriptions
-- TODO: add groups and icons
local spec = {
  {
    mode = { 'n', 'v' },
    -- TODO: add each bracket mapping manually
    { '[', group = 'prev' },
    { ']', group = 'next' },
    { 'g', group = 'goto' },
    { 'z', group = 'fold' },
  },
  {
    mode = { 'n' },
    { 'co', group = 'comment below' },
    { 'cO', group = 'comment above' },
    { '<leader>b', group = 'buffers', icon = { icon = '' } },
    { '<leader>c', group = 'code' },
    { '<localleader>l', group = 'vimtex' },
    { '<localleader>r', group = 'R', icon = { icon = ' ', color = 'blue' } },
    { '<leader>dp', group = 'profiler', icon = {icon = '⚡' }},
    { '<leader>f', group = 'find' },
    { '<leader>g', group = 'git' },
    { '<leader>s', group = 'search' },
    { '<leader>u', group = 'ui' },

    -- descriptions
    { 'gx', desc = 'Open with system app' },
    { 'ga', mode = 'x', desc = 'Align' },
    { 'gA', mode = 'x', desc = 'Align (preview)' },
  },
  { hidden = true, { 'g~' }, { 'g#' }, { 'g*' } },
}

-- from lazyvim
local objects = {
  { ' ', desc = 'whitespace' },
  { '"', desc = '" string' },
  { "'", desc = "' string" },
  { '(', desc = '() block' },
  { ')', desc = '() block with ws' },
  { '<', desc = '<> block' },
  { '>', desc = '<> block with ws' },
  { '?', desc = 'user prompt' },
  { '[', desc = '[] block' },
  { ']', desc = '[] block with ws' },
  { '_', desc = 'underscore' },
  { '`', desc = '` string' },
  { 'a', desc = 'argument' },
  { 'b', desc = ')]} block' },
  { 'c', desc = 'class' },
  { 'd', desc = 'digit(s)' },
  { 'e', desc = 'CamelCase / snake_case' },
  { 'f', desc = 'function' },
  { 'g', desc = 'entire file' },
  { 'i', desc = 'indent' },
  { 'o', desc = 'block, conditional, loop' },
  { 'q', desc = 'quote `"\'' },
  { 't', desc = 'tag' },
  { 'u', desc = 'use/call' },
  { 'U', desc = 'use/call without dot' },
  { '{', desc = '{} block' },
  { '}', desc = '{} with ws' },
}

---@type table<string, string>
local mappings = {
  around = 'a',
  inside = 'i',
  around_next = 'an',
  inside_next = 'in',
  around_last = 'al',
  inside_last = 'il',
}
-- mappings.goto_left = nil
-- mappings.goto_right = nil

---@type wk.Spec[]
local ret = { mode = { 'o', 'x' } }

-- TODO: merge with mini ai spec and add descriptions for those mappings too
vim.iter(mappings):each(function(name, prefix)
  name = name:match('^%a+_(.+)') or name
  ret[#ret + 1] = { prefix, group = name }
  vim.iter(objects):each(function(obj)
    local desc = obj.desc
    if prefix:sub(1, 1) == 'i' then
      desc = desc:gsub(' with ws', '')
    end
    ret[#ret + 1] = { prefix .. obj[1], desc = obj.desc }
  end)
end)

spec = vim.list_extend(spec, ret)

return {
  'folke/which-key.nvim',
  ---@class wk.Opts
  opts = {
    keys = { scroll_down = '<C-j>', scroll_up = '<C-k>' },
    preset = 'helix',
    replace = {
      desc = {
        -- { '<Plug>%(?(.*)%)?', '%1' },
        { '^%+', '' },
        { '<[cC]md>', '' },
        { '<[cC][rR]>', '' },
        { '<[sS]ilent>', '' },
        { '^lua%s+', '' },
        { '^call%s+', '' },
        -- { '^:%s*', '' },
      },
    },
    show_help = false,
    sort = { 'order', 'alphanum', 'case', 'mod' },
    spec = spec,
  },
  after = function()
    -- HACK: global key registration
    -- require(
    require('which-key').add(nv.plug.get_keys())
    local registers = '*+"-:.%/#=_0123456789qZ'
    require('which-key.plugins.registers').registers = registers
    -- see rules at  ~/.local/share/nvim/site/pack/core/opt/which-key.nvim/lua/which-key/icons.lua
  end,
  keys = {
    { '<leader>d', group = 'debug' },
    { '<leader>db', '<Cmd>Blink status<CR>', desc = 'Blink Status' },
    {
      '<leader>dc',
      '<Cmd>=vim.lsp.get_clients()[1].server_capabilities<CR>',
      desc = 'LSP Capabilities',
    },
    { '<leader>dd', '<Cmd>LazyDev debug<CR>', desc = 'LazyDev Debug' },
    { '<leader>dh', '<Cmd>packloadall<Bar>checkhealth<CR>', desc = 'Check Health' },
    { '<leader>dl', '<Cmd>LazyDev lsp<CR>', desc = 'LazyDev LSP' },
    { '<leader>dP', '<Cmd>=vim.tbl_keys(package.loaded)<CR>', desc = 'Loaded Packages' },
    { '<leader>dR', '<Cmd>=require("r.config").get_config()<CR>', desc = 'R Config' },
    { '<leader>dS', '<Cmd>=require("snacks").meta.get()<CR>', desc = 'Snacks Meta' },
    {
      '<leader>dw',
      '<Cmd>=vim.lsp.buf.list_workspace_folders()<CR>',
      desc = 'LSP Workspace Folders',
    },
  },
}
