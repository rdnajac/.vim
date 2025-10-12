-- Shells can emit the "OSC 7" sequence to announce when the current directory (CWD) changed.

-- You can configure your shell init (e.g. ~/.bashrc) to emit OSC 7, or your terminal may attempt to do it for you.

-- To configure bash to emit OSC 7:
-- print_osc7() { printf '\033]7;file://%s\033\\' "$PWD"; }
-- PROMPT_COMMAND='print_osc7'

-- Having ensured that your shell emits OSC 7, you can now handle it in Nvim. The
-- following code will run :lcd whenever your shell CWD changes in a :terminal
vim.api.nvim_create_autocmd({ 'TermRequest' }, {
  desc = 'Handles OSC 7 dir change requests',
  callback = function(ev)
    local val, n = string.gsub(ev.data.sequence, '\027]7;file://[^/]*', '')
    if n > 0 then
      -- OSC 7: dir-change
      local dir = val
      if vim.fn.isdirectory(dir) == 0 then
        vim.notify('invalid dir: '..dir)
        return
      end
      vim.b[ev.buf].osc7_dir = dir
      if vim.api.nvim_get_current_buf() == ev.buf then
        vim.cmd.lcd(dir)
      end
    end
  end
})

   -- printf "\033]7;file://./foo/bar\033\\"

