return {
  'MeanderingProgrammer/render-markdown.nvim',
  --- @module "render-markdown"
  --- @type render.md.UserConfig
  opts = {
    file_types = { 'markdown', 'rmd', 'quarto' },
    bullet = { right_pad = 1 },
    completions = { blink = { enabled = false } },
    -- checkbox = { enabled = false },
    code = {
      enabled = true,
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
}
