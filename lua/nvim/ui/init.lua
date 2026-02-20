local M = {}

M.after = function()
  -- requires nvim 0.12
  M.winbar = require('nvim.ui.winbar')
  vim.o.winbar = [[%{%v:lua.nv.ui.winbar()%}]]

  local signs = (function()
    local icon, hl = {}, {}
    ---@type number, string
    for k, v in ipairs(vim.diagnostic.severity) do
      local name = nv.capitalize(v --[[@as string]])
      icon[k] = nv.icons.diagnostics[name] or name:sub(1, 1)
      hl[k] = 'Diagnostic' .. name
    end
    return { text = icon, numhl = hl }
  end)()

  ---@type vim.diagnostic.Opts
  local opts = {
    float = { source = true },
    underline = false,
    virtual_text = false,
    severity_sort = true,
    signs = signs,
    status = signs,
  }

  local unused = 'smoke test'

  vim.diagnostic.config(opts)
end

M.specs = {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    enabled = false,
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

return M
