#!/usr/bin/env -S nvim -l
local uv = vim.uv

local backupdir = type(vim.o.backupdir) == 'string' and vim.o.backupdir
  or vim.fs.joinpath(vim.fn.stdpath('data'), 'backup')
backupdir = vim.fn.expand(backupdir)

-- Compute longest common prefix of a list of strings
local function longest_common_prefix(strings)
  if #strings == 0 then
    return ''
  end
  local prefix = strings[1]
  for i = 2, #strings do
    local s = strings[i]
    local j = 1
    while j <= #prefix and j <= #s and prefix:sub(j, j) == s:sub(j, j) do
      j = j + 1
    end
    prefix = prefix:sub(1, j - 1)
    if prefix == '' then
      break
    end
  end
  return prefix
end

-- Restore a single backup file into restore_dir
local function restore_backup(file, restore_dir, common_prefix)
  restore_dir = vim.fn.expand(restore_dir)

  -- read backup file
  local backup_path = vim.fs.joinpath(backupdir, file)
  local stat = uv.fs_stat(backup_path)
  if not stat or stat.type ~= 'file' then
    print('Backup file not found:', backup_path)
    return
  end
  local fd = assert(uv.fs_open(backup_path, 'r', 438))
  local content = uv.fs_read(fd, stat.size, 0)
  uv.fs_close(fd)

  -- remove common prefix and .bak extension
  local restored_file = file:sub(#common_prefix + 1):gsub('%.bak$', '')
  restored_file = restored_file:gsub('%%', '/') -- reconstruct relative path
  local restored_path = vim.fs.joinpath(restore_dir, restored_file)
  local restored_dir = vim.fs.dirname(restored_path)

  -- create directories recursively
  local function mkdir_recursive(path)
    local parent = vim.fs.dirname(path)
    if uv.fs_stat(parent) == nil then
      mkdir_recursive(parent)
    end
    if uv.fs_stat(path) == nil then
      uv.fs_mkdir(path, 448)
    end
  end
  mkdir_recursive(restored_dir)

  -- write restored file
  local fdw = assert(uv.fs_open(restored_path, 'w', 438))
  uv.fs_write(fdw, content, 0)
  uv.fs_close(fdw)

  print('Restored:', restored_path)
end

-- Restore multiple backups
local function restore_backups(files, restore_dir)
  local prefix = longest_common_prefix(files)
  for _, f in ipairs(files) do
    restore_backup(f, restore_dir, prefix)
  end
end

-- Example usage
local files = {
  '%Users%rdn%GitHub%palomerolab%ngs%rnaseq%R%counts2dds.R.bak',
  '%Users%rdn%GitHub%palomerolab%ngs%rnaseq%R%load_or_build_dds.R.bak',
  '%Users%rdn%GitHub%palomerolab%ngs%rnaseq%R%plot_pca.R.bak',
  '%Users%rdn%GitHub%palomerolab%ngs%rnaseq%experiments%PHIP%common_genes.qmd.bak',
  '%Users%rdn%GitHub%palomerolab%ngs%rnaseq%experiments%PHIP%phip.qmd.bak',
  '%Users%rdn%GitHub%palomerolab%ngs%rnaseq%experiments%PHIP%phip1.qmd.bak',
}

local restore_dir = '~/restored_backups'
restore_backups(files, restore_dir)
