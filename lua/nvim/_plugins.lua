return {
  {
    'folke/sidekick.nvim',
    -- BUG: `https://github.com/folke/sidekick.nvim/issues/264`
    -- enabled = false,
    opts = function()
      vim.schedule(vim.lsp.inline_completion.enable)
      return {
        tools = {
          -- BUG: https://github.com/folke/sidekick.nvim/issues/258
          copilot = { cmd = { 'copilot', '--banner', '--alt-screen off' } },
        },
      }
    end,
    -- stylua: ignore
    keys = {
      { mode = 'n', expr = true, '<Tab>',
        function() return
	  require('sidekick').nes_jump_or_apply() and '' or '<Tab>'
	end
      },
      -- { '<leader>a', group = 'ai', mode = { 'n', 'v' } },
      { '<leader>aa', function() require('sidekick.cli').toggle('copilot') end, desc = 'Sidekick Toggle CLI', },
      { '<leader>aA', function() require('sidekick.cli').toggle() end, desc = 'Sidekick Toggle CLI', },
      { '<leader>ad', function() require('sidekick.cli').close() end, desc = 'Detach a CLI Session', },
      { '<leader>ap', function() require('sidekick.cli').prompt() end, desc = 'Sidekick Select Prompt', mode = { 'n', 'x' }, },
      { '<leader>at', function()
          local msg = vim.fn.mode():sub(1, 1) == 'n' and '{file}' or '{this}'
          require('sidekick.cli').send({ name = 'copilot', msg = msg })
        end, mode = { 'n', 'x' }, desc = 'Send This (file/selection)',
      },
      { '<C-.>', mode = { 'n', 't', 'i', 'x' }, function() require('sidekick.cli').toggle('copilot') end, },
     },
    toggles = {
      ['<leader>uN'] = {
        name = 'Sidekick NES',
        get = function() return require('sidekick.nes').enabled end,
        set = function(state) require('sidekick.nes').enable(state) end,
      },
    },
  },
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
  {
    'R-nvim/R.nvim',
    init = function()
      local debug_r = function()
        local word = vim.fn.expand('<cword>')
        local row, col = unpack(vim.api.nvim_win_get_cursor(0))
        -- copy the <cword> to a new line below the current line
        vim.api.nvim_buf_set_lines(0, row, row, true, { word })
        -- move cursor to the new line
        vim.api.nvim_win_set_cursor(0, { row + 1, 0 })
        -- execute <Plug>RInsertLineOutput from normal mode
        vim.api.nvim_feedkeys(vim.keycode('<Plug>RInsertLineOutput'), 'n', false)
        -- delete the line with the word
        vim.api.nvim_buf_set_lines(0, row, row + 1, true, {})
        -- move cursor back to original position
        vim.api.nvim_win_set_cursor(0, { row, col })
      end

      require('r').setup({
        R_args = { '--quiet', '--no-save' },
        -- user_maps_only = true,
        -- quarto_chunk_hl = { highlight = false },
        Rout_more_colors = true,
        hook = {
          after_R_start = function()
            vim.notify('R started!')
            vim.keymap.set('n', '<leader>ur', debug_r, { desc = 'Debug R' })
          end,
          -- after_ob_open = function() vim.notify('Object Browser') end,
        },
      })
    end,
  },
}
