# Testing netrw_exmarks

This file contains instructions for testing the netrw git status extmarks feature.

## Setup

The netrw_exmarks module is automatically loaded through `lua/nvim/config/netrw.lua` when the vim configuration is initialized.

## Manual Testing

To test manually, create a git repository with some changes:

```bash
cd /tmp
mkdir test-netrw-git
cd test-netrw-git
git init
git config user.email "test@example.com"
git config user.name "Test User"

# Create some files
echo "test content" > file1.txt
echo "another file" > file2.txt
git add .
git commit -m "Initial commit"

# Make some changes
echo "modified" >> file1.txt
echo "new file" > file3.txt
```

Then open netrw in this directory:

```vim
:e /tmp/test-netrw-git/
```

You should see git status indicators in the sign column:
- `◌` for ignored files/directories (.git/)
- `●` for modified files (file1.txt)
- `?` for untracked files (file3.txt)
- ` ` (space) for unmodified files (file2.txt)

## Expected Behavior

The sign column should show two columns (`:set signcolumn=yes:2`):
1. Left column: Index status (staging area)
2. Right column: Working tree status

Files should be marked with appropriate symbols based on their git status.

## Troubleshooting

If signs don't appear:

1. Check that the buffer is a netrw buffer: `:set filetype?` should show `netrw`
2. Check that signcolumn is enabled: `:set signcolumn?` should show `yes:2`
3. Check for extmarks: `:lua print(#vim.api.nvim_buf_get_extmarks(0, vim.api.nvim_create_namespace('netrw-git-status'), 0, -1, {}))`
4. Verify git is working: `:!git status` from within the directory

## Implementation Details

The implementation consists of:

1. `lua/nvim/util/git/netrw_exmarks.lua` - Main module that:
   - Parses netrw buffer lines to extract filenames
   - Runs `git status` to get file statuses
   - Sets extmarks with appropriate signs and highlight groups

2. `lua/nvim/config/netrw.lua` - Configuration that:
   - Calls `setup()` to initialize the module
   - Ensures signcolumn is enabled for netrw buffers

3. Autocmds triggered on:
   - `FileType netrw` - Initial setup
   - `BufReadPost`, `BufWritePost`, `BufEnter` - Reload git status
   - `TextChanged`, `TextChangedI` - Refresh extmarks

## Highlight Groups

The following highlight groups are used:

- `NetrwGitStatusIndex*` - For staging area status (linked to `DiagnosticSignInfo`)
- `NetrwGitStatusWorkingTree*` - For working tree status (linked to `DiagnosticSignWarn`)

Where `*` can be:
- `Ignored`, `Untracked`, `Added`, `Copied`, `Deleted`, `Modified`, `Renamed`, `TypeChanged`, `Unmerged`, `Unmodified`
