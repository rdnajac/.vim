--- init.lua
T1 = vim.uv.hrtime()
vim.loader.enable()

require('vim._core.ui2').enable({
  msg = { target = 'msg' },
})

vim.cmd([[
colorscheme tokyonight
source ~/.vim/vimrc
command! News exe 'e' nvim_get_runtime_file('doc/news.txt', v:false)[0]
]])

_G.Plug = require('plug')

Plug({
  'folke/snacks.nvim',
  opts = {
    dashboard = {
      sections = {
        { section = 'header' },
        {
          { icon = '󰱼 ', title = 'Files', { section = 'recent_files', indent = 2 } },
          { icon = ' ', desc = 'Health ', key = 'H', action = ':checkhealth' },
          { icon = '󰒲 ', desc = 'LazyGit', key = 'G', action = ':lua Snacks.lazygit()' },
          { icon = ' ', desc = 'Mason  ', key = 'M', action = ':Mason' },
          { icon = ' ', desc = 'News   ', key = 'N', action = ':News' },
          { icon = ' ', desc = 'Update ', key = 'U', action = ':lua vim.pack.update()' },
        },
      -- stylua: ignore
      { section = 'terminal', cmd = [[cowsay "The computing scientist's main challenge is not to get confused by the complexities of his own making"  | sed "s/^/        /" ]], },
        function() return { footer = 'NVIM ' .. tostring(vim.version()), padding = 1 } end,
      },
    },
    explorer = { replace_netrw = true, trash = true },
    image = { enabled = true },
    indent = { indent = { only_current = false, only_scope = true } },
    input = { enabled = true },
    -- notifier = require('munchies.notifier'),
    notifier = { enabled = true },
    quickfile = { enabled = true },
    picker = {
      sources = require('munchies.pickers'),
    },
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
      { { 'n' }, ',,', Snacks.picker.buffers },
      { { 'n' }, ',.', Snacks.scratch.open },
      { { 'n', 't' }, '<C-Bslash>', Snacks.terminal.toggle },
      { { 'n', 't' }, ']]', function() Snacks.words.jump(vim.v.count1) end },
      { { 'n', 't' }, '[[', function() Snacks.words.jump(-vim.v.count1) end },
      { 'dI', 'dai', { desc = 'Delete (Snacks) Indent', remap = true } },
      { 'vI', 'vai', { desc = 'Select (Snacks) Indent', remap = true } },
      -- stylua: ignore
      { { 'i' }, '<C-x><C-i>', function() Snacks.picker.icons({ layout = require('munchies.layouts').insert }) end, },
    }
  end,
})

_G.dd = Snacks.debug.inspect
_G.bt = Snacks.debug.backtrace
_G.p = Snacks.debug.profile

_G.nv = require('nvim')

Plug(require('plugins'))

-- set up mini modules after nvim plugins, but before `plugin/*`
nv.mini.init()

-- lazy load treesitter plugins when not opening a file
local after = function() Plug(nv.treesitter.specs) end
if vim.fn.argc(-1) == 0 then
  after()
else
  vim.schedule(after)
end
