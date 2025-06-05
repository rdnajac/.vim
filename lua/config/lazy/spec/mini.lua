return {
  { 'echasnovski/mini.pairs', enabled = false },
  {
    'echasnovski/mini.nvim',
    event = 'VeryLazy',
    init = function()
      package.preload['nvim-web-devicons'] = function()
        require('mini.icons').mock_nvim_web_devicons()
        return package.loaded['nvim-web-devicons']
      end
    end,
    config = function()
      require('mini.icons').setup({
        file = {
          ['.keep'] = { glyph = '󰊢', hl = 'MiniIconsGrey' },
          ['devcontainer.json'] = { glyph = '', hl = 'MiniIconsAzure' },
          ['dot_zshrc'] = { glyph = '', hl = 'MiniIconsGreen' },
          ['dot_zshenv'] = { glyph = '', hl = 'MiniIconsGreen' },
          ['dot_zprofile'] = { glyph = '', hl = 'MiniIconsGreen' },
          ['dot_zshprofile'] = { glyph = '', hl = 'MiniIconsGreen' },
          ['.chezmoiignore'] = { glyph = '', hl = 'MiniIconsGrey' },
          ['.chezmoiremove'] = { glyph = '', hl = 'MiniIconsGrey' },
          ['.chezmoiroot'] = { glyph = '', hl = 'MiniIconsGrey' },
          ['.chezmoiversion'] = { glyph = '', hl = 'MiniIconsGrey' },
          ['bash.tmpl'] = { glyph = '', hl = 'MiniIconsGrey' },
          ['json.tmpl'] = { glyph = '', hl = 'MiniIconsGrey' },
          ['sh.tmpl'] = { glyph = '', hl = 'MiniIconsGrey' },
          ['toml.tmpl'] = { glyph = '', hl = 'MiniIconsGrey' },
          ['zsh.tmpl'] = { glyph = '', hl = 'MiniIconsGrey' },
        },
        filetype = {
          dotenv = { glyph = '', hl = 'MiniIconsYellow' },
        },
      })
    end,
  },
}
