local haxx = vim.api.nvim_create_augroup('haxx', { clear = true })

vim.api.nvim_create_autocmd('CmdlineEnter', {
  group = haxx,
  callback = function(args)
    if vim.bo[args.buf].filetype ~= 'snacks_dashboard' then
      vim.api.nvim_create_autocmd('CmdlineLeave', {
        once = true,
        callback = function()
          vim.o.laststatus = 3
        end,
      })
      vim.o.laststatus = 0
    end
  end,
})

vim.api.nvim_create_autocmd('CmdlineEnter', {
  group = haxx,
  command = 'set laststatus=0',
})

vim.api.nvim_create_autocmd('User', {
  group = haxx,
  pattern = 'TSUpdate',
  callback = function()
    require('nvim-treesitter.parsers').comment = {
      install_info = {
        path = vim.fn.expand('~/GitHub/rdnajac/tree-sitter-comment'),
        -- TODO: manage parser in this repo or with chezmoi or lazy
        -- generate = true, -- only needed if repo does not contain pre-generated `src/parser.c`
        -- TODO:
        -- generate_from_json = false, -- only needed if repo does not contain `src/grammar.json` either
        -- TODO:
        -- queries = 'queries/neovim', -- also install queries from given directory
      },
    }
  end,
})
