--- Window types each have respective filetype
--- • `cmd`: cmdline window; 'showcmd', 'showmode', 'ruler', and messages if 'cmdheight' > 0.
--- • `msg`: messages when 'cmdheight' == 0.
--- • `pager`: used for |:messages| and certain messages that should be shown in full
--- • `dialog`: used for prompt messages that expect user input

-- BUG: `msg.target` should inferred from cmdheight=0
vim.o.cmdheight = 0
require('vim._core.ui2').enable({
  msg = { target = 'msg' },
})

local M = {
  -- available on init
  icons = require('nvim.ui.icons'),
}

M.after = function()
  -- available after init
  M.winbar = require('nvim.ui.winbar')
  vim.o.winbar = [[%{%v:lua.nv.ui.winbar()%}]]

  -- TODO: get signs from icons
  local signs = { text = { ' ', ' ', ' ', '' } }
  vim.diagnostic.config({
    float = { source = true },
    underline = false,
    virtual_text = false,
    severity_sort = true,
    signs = signs,
    status = signs,
  })
end

M.specs = {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    -- enabled = false,
    init = function()
      ---@module "render-markdown"
      ---@type render.md.UserConfig
      vim.g.render_markdown_config = {
        file_types = { 'markdown', 'rmd', 'quarto' },
        latex = { enabled = false },
        bullet = { right_pad = 1 },
        -- checkbox = { enabled = false },
        completions = { blink = { enabled = false } },
        code = {
          -- TODO: fix the highlights and show ` or spaces for inline code markers
          -- inline_left = ' ',
          -- inline_right = ' ',
          -- inline_padding= 1,
          enabled = true,
          highlight = '',
          highlight_border = false,
          -- highlight_inline = 'Chromatophore',
          -- render_modes = { 'n', 'c', 't', 'i' },
          sign = false,
          conceal_delimiters = false,
          language = true,
          position = 'left',
          language_icon = true,
          language_name = false,
          language_info = false,
          width = 'block',
          min_width = 0,
          border = 'thin',
          style = 'normal',
        },
        heading = {
          sign = false,
          width = 'full',
          position = 'overlay',
          -- left_pad = { 0, 1, 2, 3, 4, 5 },
          -- icons = '',
        },
        html = {
          comment = { conceal = false },
          enabled = false,
        },
      }
    end,
    toggles = {
      ['<leader>um'] = {
        name = 'Render Markdown',
        get = function() return require('render-markdown.state').enabled end,
        set = function(state) require('render-markdown').set(state) end,
      },
    },
  },
}

local goto_file = function()
  local line = vim.api.nvim_get_current_line()
  local lineno = line:match(':(%d+)') or 0
  local cfile = vim.fn.expand('<cfile>')
  vim.fn['edit#'](cfile)
  vim.cmd('normal! ' .. lineno .. 'G')
end

vim.treesitter.language.register('markdown', { 'msg', 'pager' })

vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = { 'msg', 'pager' },
  -- group = aug,
  callback = function()
    vim.treesitter.start(0)
    vim.wo.conceallevel = 3
    vim.keymap.set('n', '<CR>', goto_file, { buffer = true, desc = 'Go to file under cursor' })
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
