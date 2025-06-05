-- by: https://gist.github.com/Leenuus/7a2ea47b88bfe16430b42e4e48122718

local function redir_vim_command(cmd)
  vim.cmd('redir => output')
  vim.cmd('silent ' .. cmd)
  vim.cmd('redir END')
  local output = vim.fn.split(vim.g.output, '\n')
  ToScratch(output, {})
end

function ToScratch(text, opts)
  opts = opts or {}
  -- opts.name = opts.name or cmd
  opts.template = table.concat(text, '\n')
  return Snacks.scratch(opts)
end

local function redir_shell_command(cmd, lines, vertical, stderr_p)
  local shell_cmd = {
    'sh',
    '-c',
    cmd,
  }

  local stdin = nil
  if #lines ~= 0 then
    stdin = lines
  end

  local stdout_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_option_value('ft', 'redir_stdout', { buf = stdout_buf })
  redir_open_win(stdout_buf, vertical)

  local stderr = nil
  if stderr_p then
    local stderr_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_set_option_value('ft', 'redir_sterr', { buf = stderr_buf })
    redir_open_win(stderr_buf, vertical, true)
    stderr = function(err, data)
      vim.schedule_wrap(function()
        if data ~= nil then
          local output = vim.fn.split(data, '\n')
          if vim.g.DEBUG then
            log.info('stdout: ' .. vim.inspect(output))
          end
          vim.api.nvim_buf_set_lines(stderr_buf, -2, -1, false, output)
        end
      end)()
    end
  end

  if vim.g.DEBUG then
    local report = string.format(
      [[lines: %s
stdin: %s
buf: %d
cmd_str: %s
shell_cmd: %s
]],
      vim.inspect(lines),
      vim.inspect(stdin),
      stdout_buf,
      cmd,
      vim.inspect(shell_cmd)
    )
    log.info(report)
  end

  vim.system(shell_cmd, {
    text = true,
    stdout = function(err, stdout)
      vim.schedule_wrap(function()
        if stdout ~= nil then
          local output = vim.fn.split(stdout, '\n')
          if vim.g.DEBUG then
            log.info('stdout: ' .. vim.inspect(output))
          end
          vim.api.nvim_buf_set_lines(stdout_buf, -2, -1, false, output)
        end
      end)()
    end,
    stderr = stderr,
    stdin = stdin,
  }, function(completed)
    -- NOTE:
    -- placeholder to make call async
  end)
end

local function redir(args)
  local cmd = args.args
  local vertical = args.smods.vertical
  local stderr_p = args.bang

  if vim.g.DEBUG then
    log.info(vim.inspect(args))
  end

  if cmd:sub(1, 1) == '!' then
    local range = args.range
    local lines
    if range == 0 then
      lines = {}
    else
      local line1 = args.line1 - 1
      local line2 = args.line2
      line2 = line1 == line2 and line1 + 1 or line2
      lines = vim.api.nvim_buf_get_lines(0, line1, line2, false)
    end

    cmd = cmd:sub(2)
    redir_shell_command(cmd, lines, vertical, stderr_p)
  else
    redir_vim_command(cmd, vertical)
  end
end

vim.api.nvim_create_user_command('Redir', redir, {
  nargs = '+',
  complete = 'command',
  range = true,
  bang = true,
})
vim.cmd([[cabbrev R Redir]])

vim.api.nvim_create_user_command('Mes', function()
  vim.cmd('Redir messages')
end, { bar = true })
vim.cmd([[cabbrev M Mes]])

local function evaler(range)
  return function(bang)
    local line = vim.fn.getline(1)
    local it = string.match(line, '^#!(.*)')

    local cmd = string.format('%sRedir%s !', range, bang and '!' or '')

    if it and it ~= '' then
      vim.cmd(cmd .. it)
    else
      vim.fn.feedkeys(':' .. cmd, 'tn')
    end
  end
end

vim.api.nvim_create_user_command('EvalFile', function(args)
  local bang = args.bang
  evaler('%')(bang)
end, { bar = true, bang = true })

vim.api.nvim_create_user_command('EvalLine', function(args)
  local bang = args.bang
  evaler('.')(bang)
end, { bar = true, bang = true })

vim.api.nvim_create_user_command('EvalRange', function(args)
  local bang = args.bang
  evaler("'<,'>")(bang)
end, { bar = true, bang = true, range = true })
