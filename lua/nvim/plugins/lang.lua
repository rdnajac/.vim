vim.g.rout_follow_colorscheme = true
return {
  { 'neovim/nvim-lspconfig' },
  {
    'mason-org/mason.nvim',
    opts = function()
      return { ui = { icons = nv.icons.mason } }
    end,
    build = ':MasonUpdate',
  },
  { 'SmiteshP/nvim-navic' },
  -- { 'b0o/SchemaStore.nvim' },
  {
    'R-nvim/R.nvim',
    --- @module "r"
    --- @type RConfigUserOpts
    opts = {
      R_args = { '--quiet', '--no-save' },
      pdfviewer = '',
      user_maps_only = true,
      quarto_chunk_hl = { highlight = false },
    },
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    --- @module "render-markdown"
    --- @type render.md.UserConfig
    opts = {
      file_types = { 'markdown', 'rmd', 'quarto' },
      latex = { enabled = false },
      bullet = { right_pad = 1 },
      -- checkbox = { enabled = false },
      completions = { blink = { enabled = false } },
      code = {
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
        position = 'inline',
        -- icons = '',
      },
      html = {
        comment = { conceal = false },
        enabled = false,
      },
    },
    after = function()
      Snacks.toggle
        .new({
          name = 'Render Markdown',
          get = function()
            return require('render-markdown.state').enabled
          end,
          set = function(state)
            require('render-markdown').set(state)
          end,
        })
        :map('<leader>um')
    end,
  },
}
