-- https://github.com/neovim/neovimadiscussions/35602
---@type table<string, fun(line1:integer,line2:integer):FormatOpts|FormatOpts[]>
local formatters = {
  stylua = function()
    local file = vim.api.nvim_buf_get_name(0)
    return {
      cmd = { 'stylua', '--indent-type=Spaces', '--indent-width=2', '--stdin-filepath', file, '-' },
      diff = 'overlap',
    }
  end,
}

vim.g.formatconf = {
  ['lua'] = formatters['stylua'],
}

-- ...

---@class FormatOpts
---@field cmd string[]
---@field range? [integer,integer]
---@field diff? "any"|"none"|"overlap"|"contain"
---@field diff_algorithm? "myers"|"minimal"|"patience"|"histogram"
---@field timeout? integer

---@param buf? integer
---@param opts? FormatOpts
local function format_buf(buf, opts)
  buf = buf or 0
  opts = vim.tbl_extend('keep', opts or {}, {
    cmd = nil,
    diff = 'contain',
    diff_algorithm = 'histogram',
    range = {}, -- [line1, line2)
    timeout = 2500,
  })
  if not vim.islist(opts.cmd) then
    vim.notify("Invalid 'cmd': expected a list", vim.log.levels.ERROR)
    return
  end
  local line1 = opts.range[1] or 1
  local line2 = opts.range[2] or vim.api.nvim_buf_line_count(buf) + 1
  local mode = vim.fn.mode()
  if vim.tbl_isempty(opts.range) and mode:match('[vV]') then
    local v1 = vim.api.nvim_win_get_cursor(0)[1]
    local v2 = vim.fn.getpos('v')[2]
    line1 = math.min(v1, v2)
    line2 = math.max(v1, v2) + 1
  end
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local file = vim.api.nvim_buf_get_name(0)
  ---@param out vim.SystemCompleted
  local on_exit = vim.schedule_wrap(function(out)
    if out.code == 0 then
      local fmt = assert(out.stdout, 'No stdout')
      local fmt_lines = vim.split(fmt, '\n')
      if opts.diff == 'none' then
        vim.api.nvim_buf_set_lines(0, 0, -1, true, fmt_lines)
        return
      end
      local lines_str = table.concat(lines, '\n') .. '\n'
      local diff_opts = { result_type = 'indices', algorithm = opts.diff_algorithm }
      local diff = vim.text.diff(lines_str, fmt, diff_opts)
      if not diff then
        return
      end
      for i = #diff, 1, -1 do
        local d = diff[i]
        local a = { d[1], d[1] + d[2] }
        local b = { d[3], d[3] + d[4] }
        local set_hunk = function()
          local repl = b[1] == b[2] and {} or vim.list_slice(fmt_lines, b[1], b[2] - 1)
          local offs = a[1] == a[2] and 0 or -1
          vim.api.nvim_buf_set_lines(0, a[1] + offs, a[2] + offs, false, repl)
        end
        if opts.diff == 'any' then
          set_hunk()
        end
        if opts.diff == 'contain' then
          if line1 <= a[1] and line2 >= a[2] then
            set_hunk()
          end
        end
        if opts.diff == 'overlap' then
          if line1 <= a[2] and a[1] <= line2 then
            set_hunk()
          end
        end
      end
    else
      vim.notify(out.stderr, vim.log.levels.ERROR)
    end
  end)
  local sysopts = { ---@type vim.SystemOpts
    stdin = lines,
    text = true,
    cwd = vim.fs.dirname(file),
    timeout = opts.timeout,
  }
  return vim.system(opts.cmd, sysopts, on_exit)
end

local format = function(range)
  range = range or {}
  local formatconf = vim.g.formatconf or {}
  local conf = formatconf[vim.bo.ft]
  if not vim.is_callable(conf) then
    return
  end
  local line1 = range[1] or 1
  local line2 = range[2] or vim.api.nvim_buf_line_count(0) + 1
  local mode = vim.fn.mode()
  if vim.tbl_isempty(range) and mode:match('[vV]') then
    local v1 = vim.api.nvim_win_get_cursor(0)[1]
    local v2 = vim.fn.getpos('v')[2]
    line1 = math.min(v1, v2)
    line2 = math.max(v1, v2) + 1
  end
  ---@diagnostic disable-next-line: redundant-parameter
  local fmt_opts = conf(line1, line2)
  fmt_opts = vim.islist(fmt_opts) and fmt_opts or { fmt_opts }
  for _, opts in ipairs(fmt_opts) do
    opts = vim.tbl_extend('keep', opts, { range = { line1, line2 } })
    format_buf(0, opts):wait()
  end
end

_G.Formatexpr = function(opts)
  local line1, line2 = vim.v.lnum, vim.v.lnum + vim.v.count
  if format({ line1, line2 }) then
  else
    return vim.lsp.formatexpr(opts)
  end
end

-- vim.o.formatexpr = 'v:lua.Formatexpr()'
-- vim.keymap.set("n", "gqag", function() format() end)
