---@module "snacks"

---@type snacks.picker.explorer.Config
local explorer_opts = {
  ignored = true,
  -- override default config function
  config = function(opts)
    local ret = require('snacks.picker.source.explorer').setup(opts)
    if vim.startswith(ret.cwd, vim.g['chezmoi#source_dir_path']) then
      ret.hidden = true
    end
    return ret
  end,
  win = {
    list = {
      keys = {
        ['-'] = 'explorer_up',
        ['<Left>'] = 'explorer_up',
        ['<Right>'] = 'confirm',
      },
    },
  },
}

-- explorer_opts = vim.tbl_extend('force', explorer_opts, require('munchies.explorer').floating_preview_config)

return explorer_opts
