local M = {}

---@type snacks.picker.Config

local scriptnames_items = function()
  local ok, result = pcall(vim.api.nvim_exec2, 'scriptnames', { output = true })
  if not ok then
    return {}
  end

  local items = {}
  for _, line in ipairs(vim.split(result.output, '\n', { plain = true, trimempty = true })) do
    local idx, path = line:match('^%s*(%d+):%s+(.*)$')
    if idx and path then
      table.insert(items, {
        formatted = path,
        text = string.format('%3d %s', idx, path),
        file = path,
        item = path,
        idx = tonumber(idx),
      })
    end
  end

  return items
end

M.scriptnames = function()
  Snacks.picker.pick({
    title = 'Scriptnames',
    items = scriptnames_items(),
    format = function(item)
      return { { item.text } }
    end,
    -- format = 'file',
    preview = 'file',
  })
end

local chezmoi_items = function()
  local ok, results = pcall(require('chezmoi.commands').list, {
    args = {
      '--path-style',
      'absolute',
      '--include',
      'files',
      '--exclude',
      'externals',
    },
  })
  if not ok then
    return {}
  end

  local items = {}
  for _, czFile in ipairs(results) do
    table.insert(items, {
      -- formatted = czFile,
      text = czFile,
      file = czFile,
      -- item = czFile,
    })
  end

  return items
end

M.chezmoi = function()
  Snacks.picker.pick({
    title = 'Chezmoi Files',
    items = chezmoi_items(),
    -- format = function(item)
    --   return { { item.text } }
    -- end,
    -- preview = 'file',
    frequency = true,
    confirm = function(picker, item)
      picker:close()
      require('chezmoi.commands').edit({
        targets = { item.text },
        args = { '--watch' },
      })
    end,
  })
end

-- https://learnvimscriptthehardway.stevelosh.com
M.hardway = {
  finder = 'grep',
  hidden = true,
  ignored = true,
  follow = false,
  cwd = vim.fn.expand('$XDG_CONFIG_HOME/vim/docs/learnvimscriptthehardway'),
  confirm = function(picker, item)
    picker:close()
    vim.cmd('!open ' .. Snacks.picker.util.path(item))
  end,
}

local lazypath_items = function()
  local path = vim.fn.stdpath('data') .. '/lazy'
  local dirs = vim.fn.glob(path .. '/*', true, true)
  local items = {}

  for _, dir in ipairs(dirs) do
    if vim.fn.isdirectory(dir) == 1 then
      table.insert(items, {
        text = vim.fn.fnamemodify(dir, ':t'),
        file = dir,
        item = dir,
      })
    end
  end

  return items
end

M.plugins = function()
  Snacks.picker.pick({
    title = 'Lazy Plugins',
    items = lazypath_items(),
    format = function(item)
      return { { item.text } }
    end,
    confirm = function(_, item)
      Snacks.picker.files({
        cwd = item.item,
      })
    end,
  })
end

M.lazy_dirs = function()
  local path = vim.fn.stdpath('data') .. '/lazy'
  local dirs = vim.fn.glob(path .. '/*', true, true)
  local items = {}

  for _, dir in ipairs(dirs) do
    if vim.fn.isdirectory(dir) == 1 then
      table.insert(items, {
        text = vim.fn.fnamemodify(dir, ':t'),
        file = dir,
      })
    end
  end

  Snacks.picker.pick({
    title = 'Lazy Dirs',
    items = items,
    format = function(item)
      return { { item.text } }
    end,
    layout = { preset = 'vscode' },
    confirm = function(_, item)
      Snacks.picker.grep({ cwd = item.file })
    end,
  })
end
return M
