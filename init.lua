--- init.lua
T1 = vim.uv.hrtime()
vim.loader.enable()
_G.P = vim.print

require('vim._core.ui2').enable({
  msg = {
    target = 'msg',
    -- TODO:
    -- targets = require('nvim.ui.2').targets,
  },
})

local ui_fts = { 'msg', 'pager' }
vim.treesitter.language.register('markdown', ui_fts)
vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = ui_fts,
  callback = function(ev)
    vim.treesitter.start(0)
    vim.wo.conceallevel = 3
    vim.keymap.set({ 'n' }, 'gf', require('nvim.fs').better_gf, { buf = ev.buf })
  end,
  desc = 'Apply markdown tree-sitter highlighting for message windows',
})

vim.cmd([[
colorscheme tokyonight
source ~/.vim/vimrc
command! News exe 'e' nvim_get_runtime_file('doc/news.txt', v:false)[0]
]])

_G.Plug = require('plug')

local shortcuts = {
  { icon = '󰱼 ', title = 'Files', { section = 'recent_files', indent = 2 } },
  { icon = ' ', desc = 'Health ', key = 'H', action = ':checkhealth' },
  { icon = '󰒲 ', desc = 'LazyGit', key = 'G', action = ':lua Snacks.lazygit()' },
  { icon = ' ', desc = 'Mason  ', key = 'M', action = ':Mason' },
  { icon = ' ', desc = 'News   ', key = 'N', action = ':News' },
  { icon = ' ', desc = 'Update ', key = 'U', action = ':lua vim.pack.update()' },
}

Plug({
  'folke/snacks.nvim',
  opts = {
    dashboard = {
      preset = { keys = shortcuts },
      sections = {
        { section = 'header' },
        { section = 'keys' },
        -- stylua: ignore
        { section = 'terminal', cmd = [[cowsay "The computing scientist's main challenge is not to get confused by the complexities of his own making"  | sed "s/^/        /" ]] },
        function() return { footer = 'NVIM ' .. tostring(vim.version()), padding = 1 } end,
      },
    },
    explorer = { replace_netrw = true, trash = true },
    image = { enabled = true },
    indent = { indent = { only_current = false, only_scope = true } },
    input = { enabled = true },
    -- notifier = require('munchies.notifier'),
    quickfile = { enabled = true },
    picker = require('munchies.picker').config,
    scope = { enabled = true },
    scroll = { enabled = true },
    -- statuscolumn = require('munchies.statuscolumn'),
    styles = { lazygit = { height = 0, width = 0 } },
    toggle = { which_key = false },
    words = { enabled = true },
  },
  keys = function()
    Snacks.keymap.set('n', 'K', vim.lsp.buf.hover, { lsp = {}, desc = 'LSP Hover' })
    Snacks.keymap.set({ 'n', 'x' }, '<M-CR>', Snacks.debug.run, { ft = 'lua' })
    Snacks.util.on_key('<Esc>', function() vim.cmd.nohlsearch() end)
    return {
      { { 'x' }, '/', Snacks.picker.grep_word },
      { { 'n' }, ',.', Snacks.scratch.open },
      { { 'n' }, ',,', Snacks.picker.buffers },
      { { 'n', 't' }, ']]', function() Snacks.words.jump(vim.v.count1) end },
      { { 'n', 't' }, '[[', function() Snacks.words.jump(-vim.v.count1) end },
      { { 'n' }, 'dI', 'dai', { desc = 'Delete (Snacks) Indent', remap = true } },
      { { 'n' }, 'vI', 'vai', { desc = 'Select (Snacks) Indent', remap = true } },
    -- stylua: ignore
    { { 'i' }, '<C-x><C-i>', function() Snacks.picker.icons({ layout = require('munchies.layouts').insert }) end }
,
    }
  end,
})

--- `require`s as all modules under `nvim/` directory
_G.nv = vim
  .iter(vim.fn.readdir(vim.fn.stdpath('config') .. '/lua/nvim'))
  :map(function(filename)
    local modname = vim.fn.fnamemodify(filename, ':r')
    local ok, mod = xpcall(require, debug.traceback, 'nvim.' .. modname)
    if not ok then
      Snacks.notify.error(('Error `require()`ing: %s:\n%s'):format(modname, mod))
    end
    return modname, mod
  end)
  :fold({}, rawset)

Plug(require('plugins'))

nv.mini.init()
