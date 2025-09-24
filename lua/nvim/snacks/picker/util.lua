local M = {}
--- @module 'snacks'

---@param picker snacks.Picker
local toggle = function(picker)
  vim.cmd('norm! dd')
  local opts = { cwd = picker.opts.cwd }
  local alt = picker.opts.source == 'grep' and 'files' or 'grep'
  picker:close()
  Snacks.picker(alt, opts)
  vim.schedule(function()
    vim.api.nvim_feedkeys(vim.keycode('<C-R>"'), 'i', false)
  end)
end

---@param picker snacks.Picker
local zoxide = function(picker)
  local opts = picker.opts
  picker:close()
  Snacks.picker.zoxide({
    confirm = function(z, item)
      z:close()
      opts.cwd = item.file
      Snacks.picker(opts)
    end,
  })
end

-- TODO: make jump work for vimscript items
-- TODO: Find command scriptnames picker in git history
M.pick_conf = {
  --- @param p snacks.Picker
  --- @param item snacks.Item
  confirm = function(p, item)
    local file = item and item.file
    if not file or file == '' then
      Snacks.notify.warn('No file associated with this item')
      return
    end
    p:action('jump', file)
  end,
}

M.opts_extend = {
  actions = {
    toggle = toggle,
    zoxide = zoxide,
  },
  config = function(opts)
    local icon_map = {
      grep = '󰱽',
      files = '',
    }
    local icon = icon_map[opts.finder]
    local name = opts.finder:sub(1, 1):upper() .. opts.finder:sub(2)
    opts.title = string.format('%s %s [ %s ]', icon, name, vim.fn.fnamemodify(opts.cwd, ':~'))
    if nv.util.is_nonempty_list(opts.ft) then
      opts.title = opts.title
        .. ' '
        .. table.concat(
          vim.tbl_map(function(f)
            return nv.icons()
          end, opts.ft),
          ' '
        )
    end
    if not opts.cwd then
      if vim.bo.filetype == 'oil' then
        opts.cwd = require('oil').get_current_dir()
        -- TODO: write project root func usinglsp
      elseif vim.fn.exists('*git#root') == 1 and vim.fn['git#root']() ~= '' then
        opts.cwd = vim.fn['git#root']()
      else
        opts.cwd = vim.fn.getcwd()
      end
    end
    return opts
  end,
  win = {
    input = {
      keys = {
        ['`'] = { 'toggle', mode = { 'i', 'n' } },
        ['~'] = { 'zoxide', mode = { 'i', 'n' } },
        ['P'] = {
          function(p)
            Snacks.debug.inspect(p.opts)
          end,
          mode = { 'n' },
        },
      },
    },
  },
}

return M
