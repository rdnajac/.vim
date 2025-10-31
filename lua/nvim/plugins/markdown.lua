return {
  'MeanderingProgramMer/render-markdown.nvim',
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
      position = 'overlay',
      -- left_pad = { 0, 1, 2, 3, 4, 5 },
      -- icons = '',
    },
    html = {
      comment = { conceal = false },
      enabled = false,
    },
  },
  -- toggles = {
  --   {
  --     '<leader>um',
  --     -- name = 'Render Markdown',
  --     get = function()
  --       return require('render-markdown.state').enabled
  --     end,
  --     set = function(state)
  --       require('render-markdown').set(state)
  --     end,
  --   },
  -- },
}
