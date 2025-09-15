local M = { 'folke/which-key.nvim' }

---@class wk.Opts
M.opts = {
  preset = 'helix',
  keys = { scroll_down = '<C-j>', scroll_up = '<C-k>' },
  show_help = false,
  sort = { 'order', 'alphanum', 'case', 'mod' },
  spec = {
    {
      {
        mode = { 'n', 'v' },
        -- TODO: add each bracket mapping manually
        { '[', group = 'prev' },
        { ']', group = 'next' },
        { 'g', group = 'goto' },
        { 'z', group = 'fold' },
      },

      mode = { 'n' },
      { 'co', group = 'comment below' },
      { 'cO', group = 'comment above' },
      { '<leader>dp', group = 'profiler' },
      { '<localleader>l', group = 'vimtex' },

      -- descriptions
      { 'gx', desc = 'Open with system app' },
    },
    { hidden = true, { 'g~' }, { 'g#' }, { 'g*' } },
  },
}

-- local map = require('which-key').add
-- TODO: combine with which-key spec
vim.keymap.set({ 'i', 'n', 's' }, '<Esc>', function()
  vim.cmd.nohlsearch()
  return '<Esc>'
end, { expr = true, desc = 'Escape and Clear hlsearch' })
-- nnoremap <expr> <Esc> ":nohlsearch\<CR><Esc>"

-- Supertab
vim.keymap.set('i', '<Tab>', function()
  local cmp = require('blink.cmp')
  local item = cmp.get_selected_item()
  local type = require('blink.cmp.types').CompletionItemKind

  -- TODO: what about snippet expansion?
  -- TODO: how to hide copilot completion?
  if not vim.lsp.inline_completion.get() then
    if cmp.is_visible() and item then
      cmp.accept()
      -- keep accepting path completions
      if item.kind == type.Path then
        vim.defer_fn(function()
          cmp.show({ providers = { 'path' } })
        end, 1)
      end
      return ''
    end
  end
  return '<Tab>'
end, { expr = true })

return M
