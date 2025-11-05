local M = { 'R-nvim/R.nvim' }

local on_filetype = function()
  vim.cmd([[
  setlocal foldmethod=expr 
  setlocal foldexpr=v:lua.vim.treesitter.foldexpr()
  setlocal iskeyword-=.
  setlocal keywordprg=:RHelp

  nmap <buffer> zq <Cmd>RFormat<CR>

  inoremap <buffer> <M--> <-<Space>
  inoremap <buffer> <M-Bslash> <Bar>><Space>
  inoremap <buffer> <space><space> viw

  nnoremap <buffer> <localleader>R <Plug>RStart
  nnoremap <buffer> ]r     <Plug>NextRChunk
  nnoremap <buffer> [r     <Plug>PreviousRChunk
  vnoremap <buffer> <CR>   <Plug>RSendSelection
  nnoremap <buffer> <CR>   <Plug>RDSendLine
  nnoremap <buffer> <M-CR> <Plug>RInsertLineOutput

  nnoremap <buffer> <localleader>r<CR> <Plug>RSendFile
  nnoremap <buffer> <localleader>rq    <Plug>RClose

  nnoremap <buffer> <localleader>ry <Cmd>RSend Y<CR>
  nnoremap <buffer> <localleader>ra <Cmd>RSend a<CR>
  nnoremap <buffer> <localleader>rn <Cmd>RSend n<CR>
  nnoremap <buffer> <localleader>rs <Cmd>RSend renv::status()<CR>
  nnoremap <buffer> <localleader>rS <Cmd>RSend renv::snapshot()<CR>
  nnoremap <buffer> <localleader>rr <Cmd>RSend renv::restore()<CR>

  nnoremap <buffer> <localleader>rq :<C-U>RSend quarto::quarto_preview(file="<C-R>=expand('%:p')<CR>")<CR>

  " TODO: are these overridden by R.nvim in after/ftplugin?
  hi clear RCodeBlock
  hi clear RCodeComment
  ]])
end

M.config = function()
  vim.g.rout_follow_colorscheme = true
  ---@module "r"
  ---@type RConfigUserOpts
  local opts = {
    R_args = { '--quiet', '--no-save' },
    user_maps_only = true,
    quarto_chunk_hl = { highlight = false },
    hook = {
      on_filetype = on_filetype,
      after_config = function()
        Snacks.util.set_hl({
          Inactive = { fg = '#aaaaaa' },
          Starting = { fg = '#757755' },
          ServerReady = { fg = '#117711' },
          TCPStart = { fg = '#ff8833' },
          TCPReady = { fg = '#3388ff' },
          RStarting = { fg = '#ff8833' },
          Ready = { fg = '#3388ff' },
        }, { prefix = 'RStatus', default = true })
      end,
      -- after_R_start = function() vim.notify('R was launched') end,
      -- after_ob_open = function() vim.notify('Object Browser') end,
    },
  }
  require('r').setup(opts)
end

local rstt = {
  { '-', 'RStatusInactive' }, -- 1: ftplugin/* sourced, but nclientserver not started yet.
  { 'S', 'RStatusStarting' }, -- 2: nclientserver started, but not ready yet.
  { 'S', 'RStatusServerReady' }, -- 3: nclientserver is ready.
  { 'S', 'RStatusTCPStart' }, -- 4: nclientserver started the TCP server
  { 'S', 'RStatusTCPReady' }, -- 5: TCP server is ready
  { 'R', 'RStatusRStarting' }, -- 6: R started, but nvimcom was not loaded yet.
  { 'R', 'RStatusReady' }, -- 7: nvimcom is loaded.
}

M.status = {
  function()
    return rstt[vim.g.R_Nvim_status][1]
  end,
  color = function()
    return rstt[vim.g.R_Nvim_status][2]
  end,
  cond = function()
    if not vim.tbl_contains({ 'r', 'rmd', 'quarto' }, vim.bo.filetype) then
      return false
    end
    return vim.g.R_Nvim_status and vim.g.R_Nvim_status > 0
  end,
}

return M
