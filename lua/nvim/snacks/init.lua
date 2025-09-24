local M = { 'folke/snacks.nvim' }

-- stylua: ignore
local _enabled = {
  bigfile      = { enabled = true  },
  dashboard    = { enabled = true  },
  explorer     = { enabled = true  },
  image        = { enabled = true  },
  indent       = { enabled = true  },
  input        = { enabled = true  },
  notifier     = { enabled = true  },
  quickfile    = { enabled = true  },
  scope        = { enabled = true  },
  scroll       = { enabled = false },
  statuscolumn = { enabled = false },
  words        = { enabled = true  },
}
local skip = {} -- upvalue

M.after = function()
  -- capture the methods we want to skip
  skip = vim.tbl_keys(Snacks.picker)

  _G.bt = Snacks.debug.backtrace
  -- bt()
  require('nvim.snacks.terminal')
end

---@module "snacks"
---@type snacks.config
local opts = {
  dashboard = require('nvim.snacks.dashboard'),
  explorer = { replace_netrw = vim.g.default_file_explorer == 'snacks' },
  indent = { indent = { only_current = true, only_scope = true } },
  notifier = require('nvim.snacks.notifier'),
  picker = require('nvim.snacks.picker'),
  scratch = { template = 'local x = \n\nprint(x)' },
  terminal = { start_insert = false, auto_insert = true, auto_close = true },
  styles = {
    dashboard = { wo = { winhighlight = 'WinBar:NONE' } },
    lazygit = { height = 0, width = 0 },
    terminal = { wo = { winbar = '', winhighlight = 'Normal:Character' } },
  },
}

-- TODO: use the snacks.config.merge functions
M.opts = vim.tbl_deep_extend('force', opts, _enabled)

M.keys = function()
  require('nvim.snacks.toggle') -- set up toggles
  local all = { hidden = true, nofile = true } -- opts for buffers (all)
-- stylua: ignore
local keys = {
{ '<leader><space>', function() Snacks.picker.smart() end,   desc = 'Smart Find Files'              },
{ '<leader>,', function() Snacks.picker.buffers() end,       desc = 'Buffers'                       },
{ '<leader>/', function() Snacks.picker.grep() end,          desc = 'Grep'                          },
{ '<leader>e', function() Snacks.explorer() end,             desc = 'File Explorer'                 },

-- buffers
{ ',,',         function() Snacks.picker.buffers() end,      desc = 'Buffers'                       },
{ '<leader>bb', function() Snacks.picker.buffers() end,      desc = 'Buffers'                       },
{ '<leader>bB', function() Snacks.picker.buffers(all) end,   desc = 'Buffers (all)'                 },
{ '<leader>bl', function() Snacks.picker.lines() end,        desc = 'Buffer Lines'                  },
{ '<leader>bg', function() Snacks.picker.grep_buffers() end, desc = 'Grep Open Buffers'             },
{ '<leader>bd', function() Snacks.bufdelete() end,           desc = 'Delete Buffer'                 },
{ '<leader>bD', function() Snacks.bufdelete.other() end,     desc = 'Delete Other Buffers'          },

-- find
{ '<leader>fb', function() Snacks.picker.buffers() end,      desc = 'Buffers'                       },
{ '<leader>ff', function() Snacks.picker.files() end,        desc = 'Find Files'                    },
{ '<leader>fg', function() Snacks.picker.git_files() end,    desc = 'Find Git Files'                },
{ '<leader>fp', function() Snacks.picker.projects() end,     desc = 'Projects'                      },
{ '<leader>fr', function() Snacks.picker.recent() end,       desc = 'Recent'                        },

-- git
{ '<leader>gB', function() Snacks.gitbrowse() end,           desc = 'Git Browse'                    },
{ '<leader>gb', function() Snacks.picker.git_branches() end, desc = 'Git Branches'                  },
{ '<leader>gd', function() Snacks.picker.git_diff() end,     desc = 'Git Diff'                      },
{ '<leader>gf', function() Snacks.picker.git_log_file() end, desc = 'Git Log File'                  },
{ '<leader>gL', function() Snacks.picker.git_log_line() end, desc = 'Git Log Line'                  },
{ '<leader>gl', function() Snacks.picker.git_log() end,      desc = 'Git Log'                       },
{ '<leader>gs', function() Snacks.picker.git_status() end,   desc = 'Git Status'                    },
{ '<leader>gS', function() Snacks.picker.git_stash() end,    desc = 'Git Stash'                     },
{ '<leader>gg', function() Snacks.lazygit() end,             desc = 'Lazygit' ,                     },

-- search/grep
{ '<leader>s"', function() Snacks.picker.registers() end,            desc = 'Registers'             },
{ '<leader>s/', function() Snacks.picker.search_history() end,       desc = 'Search History'        },
{ '<leader>s:', function() Snacks.picker.command_history() end,      desc = 'Command History'       },
{ '<leader>sa', function() Snacks.picker.autocmds() end,             desc = 'Autocmds'              },
{ '<leader>sb', function() Snacks.picker.lines() end,                desc = 'Buffer Lines'          },
{ '<leader>sB', function() Snacks.picker.grep_buffers() end,         desc = 'Grep Open Buffers'     },
{ '<leader>sC', function() Snacks.picker.commands() end,             desc = 'Commands'              },
{ '<leader>sd', function() Snacks.picker.diagnostics() end,          desc = 'Diagnostics'           },
{ '<leader>sD', function() Snacks.picker.diagnostics_buffer() end,   desc = 'Buffer Diagnostics'    },
{ '<leader>sh', function() Snacks.picker.help() end,                 desc = 'Help Pages'            },
{ '<leader>sH', function() Snacks.picker.highlights() end,           desc = 'Highlights'            },
{ '<leader>si', function() Snacks.picker.icons() end,                desc = 'Icons'                 },
{ '<leader>sj', function() Snacks.picker.jumps() end,                desc = 'Jumps'                 },
{ '<leader>sk', function() Snacks.picker.keymaps() end,              desc = 'Keymaps'               },
{ '<leader>sl', function() Snacks.picker.loclist() end,              desc = 'Location List'         },
{ '<leader>sm', function() Snacks.picker.marks() end,                desc = 'Marks'                 },
{ '<leader>sM', function() Snacks.picker.man() end,                  desc = 'Man Pages'             },
{ '<leader>sn', function() Snacks.picker.notifications() end,        desc = 'Notification History'  },
{ '<leader>sq', function() Snacks.picker.qflist() end,               desc = 'Quickfix List'         },
{ '<leader>sR', function() Snacks.picker.resume() end,               desc = 'Resume'                },
{ '<leader>sw', function() Snacks.picker.grep_word() end,            desc = 'Grep <cword>'          },
{ '<leader>su', function() Snacks.picker.undo() end,                 desc = 'Undo History'          },
-- ui
{ '<leader>uC', function() Snacks.picker.colorschemes() end,         desc = 'Colorschemes'          },
{ '<leader>uz', function() Snacks.zen() end,                         desc = 'Zen Mode'              },
{ '<leader>z',  function() Snacks.zen() end,                         desc = 'Toggle Zen Mode'       },
{ '<leader>Z',  function() Snacks.zen.zoom() end,                    desc = 'Toggle Zoom'           },
-- other
{ '<leader>.',  function() Snacks.scratch() end,                     desc = 'Toggle Scratch Buffer' },
{ '<leader>S',  function() Snacks.scratch.select() end,              desc = 'Select Scratch Buffer' },
{ '<leader>n',  function() Snacks.notifier.show_history() end,       desc = 'Notification History'  },
{ '<leader>un', function() Snacks.notifier.hide() end,               desc = 'Dismiss Notifications' },
{ '<leader>cR', function() Snacks.rename.rename_file() end,          desc = 'Rename File'           },
-- LSP
{ 'grd', function() Snacks.picker.lsp_definitions() end,             desc = 'LSP Definition'        },
{ 'grD', function() Snacks.picker.lsp_declarations() end,            desc = 'LSP Declaration'       },
{ 'grR', function() Snacks.picker.lsp_references() end,              desc = 'LSP References'        },
{ 'grI', function() Snacks.picker.lsp_implementations() end,         desc = 'LSP Implementation'    },
{ 'grT', function() Snacks.picker.lsp_type_definitions() end,        desc = 'LSP Type Definition'   },
{ '<leader>ss', function() Snacks.picker.lsp_symbols() end,          desc = 'LSP Symbols'           },
{ '<leader>sS', function() Snacks.picker.lsp_workspace_symbols() end,desc = 'LSP Workspace Symbols' },
{ ']]', function() Snacks.words.jump(vim.v.count1) end,mode={'n','t'},desc = 'Next Reference'       },
{ '[[', function() Snacks.words.jump(-vim.v.count1)end,mode={'n','t'},desc = 'Prev Reference'       },
  {
    '<leader>N', function()
      Snacks.zen({win={file=vim.api.nvim_get_runtime_file('doc/news.txt', false)[1]}})
    end, desc = 'Neovim News'
  }
}

  --- Create a pair of which-key specs for mapping a file picker and a grep picker
  ---@param desc string Description of the mapping
  ---@param key string The key to bind the pickers to (appended to <leader>f and <leader>s)
  ---@param picker_opts? table Options to pass to the pickers
  local function picker_pair(desc, key, dir, picker_opts)
    local opts = picker_opts or {}
    opts.cwd = vim.fn.expand(dir)
    -- stylua: ignore
    return {
      { '<leader>f' .. key, function() Snacks.picker.files(opts) end, desc = desc },
      { '<leader>s' .. key, function() Snacks.picker.grep(opts)  end, desc = desc },
    }
  end

  local picker_pairs = {
    Dotfiles = { '.', vim.g['chezmoi#source_dir_path'], { hidden = true } },
    DataFiles = { 'd', vim.fn.stdpath('data') },
    GitHubRepos = { 'G', '~/GitHub/' },
    ConfigFiles = { 'c', vim.fn.stdpath('config'), { ft = { 'lua', 'vim' } } },
    VIM = { 'V', '$VIM', { ft = { 'lua', 'vim' } } },
    VIMRUNTIME = { 'v', '$VIMRUNTIME', { ft = { 'lua', 'vim' } } },
    Plugins = { 'P', vim.g.plug_home, { ft = { 'lua', 'vim' } } },
  }

  -- add the mappings to the keys table
  for desc, args in pairs(picker_pairs) do
    local key, dir, opts = unpack(args)
    vim.list_extend(keys, picker_pair(desc, key, dir, opts))
  end
  -- no hlsearch on <Esc>
  -- vimscript: nnoremap <expr> <Esc> ':nohlsearch\<CR><Esc>'
  -- vim.keymap.set({ 'i', 'n', 's' }, '<Esc>', function()
  --   vim.cmd.nohlsearch()
  --   return '<Esc>'
  -- end, { expr = true, desc = 'Escape and Clear hlsearch' })

  -- stylua: ignore start
  Snacks.util.on_key('<Esc>', function() vim.cmd.nohlsearch() end)
  vim.keymap.set('v', '<leader>/', function() Snacks.picker.grep_word() end)
  vim.keymap.set('n', '<leader>ui', function() vim.show_pos() end, { desc = 'Inspect Pos' })
  vim.keymap.set({'n','t'}, '<c-\\>', function() Snacks.terminal.toggle() end)
  vim.keymap.set('n', '<leader>sW', 'viW<Cmd>lua Snacks.picker.grep_word()<CR>', { desc = 'Grep <cWORD>' })
  --stylua: ignore end

  return keys
end

M.commands = function()
  --- assumes input is [a-z],_
  local function to_camel_case(str)
    return str
      :gsub('_(%a)', function(c)
        return c:upper()
      end)
      :gsub('^%l', string.upper)
  end

  -- add any additional methods to skip creating commands for
  vim.list_extend(skip, { 'config', 'highlight', 'keymap' })
  -- also skip the lazy picker if we're not using lazy.nvim
  if not package.loaded['lazy'] then
    skip[#skip + 1] = 'lazy'
  end

  vim
    .iter(vim.tbl_keys(Snacks.picker))
    :filter(function(name)
      return not vim.list_contains(skip, name)
    end)
    :each(function(name)
      local cmd = to_camel_case(name)
      -- currently, this only guards against `:Man`
      if vim.fn.exists(':' .. cmd) ~= 2 then
        vim.api.nvim_create_user_command(cmd, function(args)
          local opts = {}
          if nv.util.is_nonempty_string(args.args) then
            --- @diagnostic disable-next-line: param-type-mismatch
            local ok, result = pcall(loadstring('return {' .. args.args .. '}'))
            if ok and type(result) == 'table' then
              opts = result
            end
          end
          Snacks.picker[name](opts)
        end, { nargs = '?', desc = 'Snacks Picker: ' .. cmd })
      end
    end)
end

return M
