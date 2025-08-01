local M = { 'github/copilot.vim' }

M.config = function()
  -- Snacks.util.set_hl({ CopilotSuggestion = { bg = '#414868', fg = '#7aa2f7' } })
  vim.deprecate = function() end -- HACK: remove this once plugin is updated
  vim.g.copilot_workspace_folders = { '~/GitHub', '~/.local/share/chezmoi/' }
  -- vim.g.copilot_no_maps = true
  -- vim.g.copilot_no_tab_map = true
  -- vim.keymap.set('i', '<C-J>', 'copilot#Accept("\\<CR>")', {
  --   expr = true,
  --   replace_keycodes = false,
  -- })
  vim.cmd([[
    augroup copilot
    autocmd!
    autocmd User BlinkCmpMenuOpen call copilot#Dismiss() | let b:copilot_suggestion_hidden = v:true
    autocmd User BlinkCmpMenuClose let b:copilot_suggestion_hidden = v:false
    " Block the normal Copilot suggestions if using blink integration
    " autocmd FileType * call copilot#OnFileType()
    " autocmd BufUnload * call copilot#OnBufUnload()
    augroup END
  ]])
end

return M
