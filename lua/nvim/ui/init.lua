vim.schedule(function()
  vim.o.statusline = [[%{%v:lua.nv.ui.status.line()%}]]
  vim.o.winbar = [[%{%v:lua.nv.ui.winbar()%}]]
end)

local M = {
  icons = require('nvim.ui.icons'),
  status = require('nvim.ui.status'),
  winbar = require('nvim.ui.winbar'),
  specs = {
    {
      'MeanderingProgrammer/render-markdown.nvim',
      init = function() require('nvim.ui.markdown') end,
    },
  },
}

--- Window types each have respective filetype
--- • `msg`: messages when 'cmdheight' == 0.
--- • `pager`: used for |:messages| and certain messages that should be shown in full
--- • `dialog`: used for prompt messages that expect user input
vim.treesitter.language.register('markdown', { 'msg', 'pager' })

vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = { 'msg', 'pager' },
  -- group = aug,
  callback = function()
    vim.treesitter.start(0)
    vim.wo.conceallevel = 3
    -- vim.keymap.set('n', '<CR>', nv.fs.goto, { buffer = true, desc = 'Go to file under cursor' })
    -- vim.cmd([[
    --   " open file in a new window when or jump to line number when appropriate
    --   " nnoremap <expr> gf &ft =~# '\vmsg\|pager' ? ''
    --   " \ : expand('<cWORD>') =~# ':\d\+$' ? 'gF' : 'gf'
    --   ]])
  end,
  desc = '',
})

M.redraw = function(t)
  vim.defer_fn(
    function()
      vim.api.nvim__redraw({ win = vim.api.nvim_get_current_win(), valid = false, flush = false })
    end,
    t or 200
  )
end

function M.spinner()
  local spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
  return spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
end

--- foldtext for lua files with treesitter folds
---@return string
M.foldtext = function()
  local indicator = '...'
  local start = vim.fn.getline(vim.v.foldstart)
  local end_ = vim.fn.getline(vim.v.foldend)
  local parts = { start }

  if vim.endswith(start, '{') then
    if vim.trim(start) == '{' then -- only '{' on the line
      local second_line = vim.fn.getline(vim.v.foldstart + 1)
      local quoted_str = second_line:match('^%s*(["\']..-["\'],?)%s*$')
      parts[#parts + 1] = quoted_str
    end
    parts[#parts + 1] = indicator
  elseif vim.endswith(start, ')') or vim.endswith(start, 'do') then
    parts[#parts + 1] = indicator
  else
    return start -- return if no special handling
  end
  parts[#parts + 1] = vim.trim(end_)
  return table.concat(parts, ' ')
end

return M
