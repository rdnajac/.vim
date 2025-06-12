langsetup({ { 'r-languageserver', 'r_languageserver' } })
local filetypes = { 'r', 'rmd', 'quarto' }

return {
  {
    'R-nvim/R.nvim',
    -- event = 'VeryLazy',
    ft = filetypes,
    init = function()
      vim.g.rout_follow_colorscheme = true
    end,
    keys = {
      { '<localleader>r', '', desc = 'R', ft = filetypes },
      { '<localleader>R', '<Plug>RStart', ft = filetypes },
    },
    ---@type RConfigUserOpts
    opts = {
      R_args = { '--quiet', '--no-save' },
      pdfviewer = '',
      user_maps_only = true,
      hook = {
        on_filetype = function()
          vim.cmd([[
            nnoremap <buffer> ]r <Plug>NextRChunk
            nnoremap <buffer> [r <Plug>PreviousRChunk
            vnoremap <buffer> <CR> <Plug>RSendSelection
            nnoremap <buffer> <CR> <Plug>RDSendLine
            nnoremap <buffer> <M-CR> <Plug>RInsertLineOutput

            nnoremap <buffer> <localleader>r<CR> <Plug>RSendFile
            nnoremap <buffer> <localleader>rq <Plug>RClose
            nnoremap <buffer> <localleader>rD <Plug>RSetwd

            nnoremap <buffer> <localleader>r? <Cmd>RSend getwd()<CR>
            nnoremap <buffer> <localleader>rR <Cmd>RSend source(".Rprofile")<CR>
            nnoremap <buffer> <localleader>rd <Cmd>RSend setwd(vim.fn.expand("<cword>"))<CR>
            nnoremap <buffer> <localleader>rs <Cmd>RSend renv::status()<CR>
            nnoremap <buffer> <localleader>rS <Cmd>RSend renv::snapshot()<CR>
            nnoremap <buffer> <localleader>rr <Cmd>RSend renv::restore()<CR>
            ]])
          vim.keymap.set('n', '<localleader>rq', function()
            vim.cmd('RSend quarto::quarto_preview(file="' .. vim.fn.expand('%:p') .. '")')
          end, { buffer = true, desc = 'Quarto Preview' })
        end,
        after_config = function()
          -- TODO: this should go in colorscheme?
          vim.cmd([[
            hi clear RCodeBlock
            hi clear RCodeComment
          ]])
        end,
      },
    },
  },
}
