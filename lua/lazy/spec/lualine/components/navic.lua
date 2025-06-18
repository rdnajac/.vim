return {
  'navic',
  color_correction = 'dynamic',
  navic_opts = {
    -- depth_limit = 9,
    depth_limit_indicator = LazyVim.config.icons.misc.dots,
    highlight = false, -- must be false for color to apply
    icons = LazyVim.config.icons.kinds,
    lazy_update_context = true,
    separator = ' ',
  },
  color = { bg = 'NONE' },
}
