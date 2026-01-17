local aug = vim.api.nvim_create_augroup('nvimrc', {})

-- audebug('DirChanged')

--- Shells can emit the "OSC 7" sequence to announce when the current directory (CWD) changed.
--- If your terminal doesn't already do this for you, you can configure your shell to emit it.
---
--- To configure bash to emit OSC 7:
--- print_osc7() { printf '\033]7;file://%s\033\\' "$PWD"; }
--- PROMPT_COMMAND='print_osc7'
---
--- Having ensured that your shell emits OSC 7, you can now handle it in Nvim. The
--- following code will run :lcd whenever your shell CWD changes in a :terminal
vim.api.nvim_create_autocmd('TermRequest', {
  desc = 'Handles OSC 7 dir change requests',
  callback = function(ev)
    local sequence = ev.data.sequence
    local dir = sequence:match('\027]7;file://[^/]*(.+)\027\\')
    if dir and vim.fn.isdirectory(dir) ~= 0 then
      vim.b[ev.buf].osc7_dir = dir
      if vim.api.nvim_get_current_buf() == ev.buf then
        vim.cmd.lcd(dir)
      end
    end
  end,
})
-- ~/.local/share/chezmoi/dot_config/zsh/dot_zshrc:65
-- printf "\033]7;file://./foo/bar\033\\"
