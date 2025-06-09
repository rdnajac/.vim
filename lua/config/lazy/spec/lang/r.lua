return {
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    opts = { ensure_installed = { 'r-languageserver' } },
  },
  {
    'R-nvim/R.nvim',
    event = 'VeryLazy',
    init = function()
      vim.g.rout_follow_colorscheme = true
    end,
    ---@type RConfigUserOpts
    opts = {
      R_args = { '--quiet', '--no-save' },
      pdfviewer = '',
      user_maps_only = true,
      hook = {
        on_filetype = function()
          vim.cmd([[
            nnoremap <buffer> ,, <Plug>RStart
            nnoremap <buffer> ]r <Plug>NextRChunk
            nnoremap <buffer> [r <Plug>PreviousRChunk
            vnoremap <buffer> <CR> <Plug>RSendSelection
            nnoremap <buffer> <CR> <Plug>RDSendLine
            nnoremap <buffer> <M-CR> <Plug>RInsertLineOutput

            nnoremap <buffer> <localleader>r<CR> <Plug>RSendFile
            nnoremap <buffer> <localleader>rq <Plug>RClose
            nnoremap <buffer> <localleader>rD <Plug>RSetwd

            nnoremap <buffer> <localleader>r? :RSend getwd()<CR>
            nnoremap <buffer> <localleader>rR :RSend source(".Rprofile")<CR>
            nnoremap <buffer> <localleader>rd :RSend setwd(vim.fn.expand("<cword>"))<CR>

            nnoremap <buffer> <localleader>rs :RSend renv::status()<CR>
            nnoremap <buffer> <localleader>rS :RSend renv::snapshot()<CR>
            nnoremap <buffer> <localleader>rr :RSend renv::restore()<CR>
          ]])
          vim.keymap.set('n', '<localleader>rq', function()
            local file = vim.fn.expand('%:p')
            vim.cmd('RSend quarto::quarto_preview(file="' .. file .. '")')
          end, { buffer = true, desc = 'Quarto Preview' })
        end,
        after_config = function()
          vim.cmd([[
            hi clear RCodeBlock
            hi clear RCodeComment
          ]])
        end,
      },
    },
  },
}
