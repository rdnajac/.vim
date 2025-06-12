langsetup({
  { 'bash-language-server', 'bash-language-server' },
  'shfmt',
  'shellcheck',
  'shellharden',
})
return {
  {
    -- highlighting for chezmoi files template files
    'alker0/chezmoi.vim',
    init = function()
      vim.g['chezmoi#use_tmp_buffer'] = 1
      vim.g['chezmoi#source_dir_path'] = os.getenv('HOME') .. '/.local/share/chezmoi'
    end,
  },
  {
    'xvzc/chezmoi.nvim',
    enabled = true,
    cmd = { 'ChezmoiEdit', 'ChezmoiList' },
    opts = {
      edit = {
        watch = false,
        force = false,
      },
    },
    init = function()
      -- vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufWritePost' }, {
      --   pattern = os.getenv('HOME') .. '/.config/vim/*',
      --   command = '!chezmoi add %',
      -- })
      -- run chezmoi edit on file enter
      vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
        pattern = { os.getenv('HOME') .. '/.local/share/chezmoi/*' },
        callback = function()
          vim.schedule(require('chezmoi.commands.__edit').watch)
        end,
      })
      -- TODO: delete?
    end,
  },
}
