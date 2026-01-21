-- assumes input is [a-z],_
local function to_camel_case(str)
  return str:gsub('_(%a)', function(c) return c:upper() end):gsub('^%l', string.upper)
end

local cmds = vim
  .iter(vim.tbl_keys(Snacks.picker))
  :filter(
    function(name)
      return not vim.list_contains({
        'config',
        'get',
        'health',
        'highlight',
        'keymap',
        'lazy',
        'meta',
        'select',
        'setup',
        'util',
      }, name)
    end
  )
  :map(function(name) return { name = name, cmd = to_camel_case(name) } end)
  :filter(function(t) return vim.fn.exists(':' .. t.cmd) ~= 2 end)
  :map(function(t)
    -- register command
    vim.api.nvim_create_user_command(t.cmd, function(args)
      local opts = {}
      if nv.is_nonempty_string(args.args) then
        ---@diagnostic disable-next-line: param-type-mismatch
        local ok, result = pcall(loadstring('return {' .. args.args .. '}'))
        if ok and type(result) == 'table' then
          opts = result
        end
      end
      Snacks.picker[t.name](opts)
    end, { nargs = '?', desc = 'Snacks Picker: ' .. t.cmd })
    -- return command name
    return t.cmd
  end)
  :totable()

return cmds

-- Actions
-- Autocmds
-- Buffers
-- Cliphist
-- Colorschemes
-- CommandHistory
-- Commands
-- Diagnostics
-- DiagnosticsBuffer
-- Explorer
-- Files
-- Format
-- GhActions
-- GhDiff
-- GhIssue
-- GhLabels
-- GhPr
-- GhReactions
-- GitBranches
-- GitDiff
-- GitFiles
-- GitGrep
-- GitLog
-- GitLogFile
-- GitLogLine
-- GitStash
-- GitStatus
-- Grep
-- GrepBuffers
-- GrepWord
-- Help
-- Highlights
-- Icons
-- Jumps
-- Keymaps
-- Lines
-- Loclist
-- LspConfig
-- LspDeclarations
-- LspDefinitions
-- LspImplementations
-- LspIncomingCalls
-- LspOutgoingCalls
-- LspReferences
-- LspSymbols
-- LspTypeDefinitions
-- LspWorkspaceSymbols
-- Marks
-- Notifications
-- Pick
-- PickerActions
-- PickerFormat
-- PickerLayouts
-- PickerPreview
-- Pickers
-- Preview
-- Projects
-- Qflist
-- Recent
-- Registers
-- Resume
-- Scratch
-- SearchHistory
-- Smart
-- Spelling
-- Tags
-- Treesitter
-- Undo
-- Zoxide
