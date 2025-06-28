function! fold#text()
  let s:foldchar = '.'
  let line1 = getline(v:foldstart)
  let indent = matchstr(line1, '^\s*')
  if line1 =~ '^\s*{'
    let next = getline(v:foldstart + 1)
    let line = indent . substitute(next, '^\s*', '{ ', '')
  else
    let line = substitute(line1, '\s*"\?\s*{{{\d*\s*$', '', '')
  endif
  let lines_count = v:foldend - v:foldstart + 1
  let lines_count_text = '|' . printf("%10s", lines_count . ' lines') . ' |'
  let pre = line .. ' '
  let post = lines_count_text
  let width = 80
  let fill = repeat(s:foldchar, max([0, width - strdisplaywidth(pre . post)]))
  return pre . fill . post
endfunction

function! fold#aware_h() abort
  let col = virtcol('.')
  let indent = indent('.')
  if col <= indent + 1 && &l:foldopen =~# 'hor'
    return 'zc'
  else
    return 'h'
  endif
endfunction


" TODO: needs testing
function! fold#pause() abort
  if &foldenable
    let b:fold_was_enabled = 1
    set nofoldenable
  endif
endfunction

function! fold#unpause() abort
  if exists('b:fold_was_enabled') && !&foldenable
    unlet b:fold_was_enabled
    set foldenable
    normal! zv
  endif
endfunction

finish

lua << EOF
-- https://www.reddit.com/r/neovim/comments/1534jt3/showcase_your_folds/
vim.keymap.set('n', '/', 'zn/', { desc = 'Search & Pause Folds' })

vim.on_key(function(char)
local key = vim.fn.keytrans(char)
local searchKeys = { 'n', 'N', '*', '#', '/', '?' }
local searchConfirmed = (key == '<CR>' and vim.fn.getcmdtype():find('[/?]') ~= nil)
if not (searchConfirmed or vim.fn.mode() == 'n') then
  return
  end
  local searchKeyUsed = searchConfirmed or (vim.tbl_contains(searchKeys, key))

  local pauseFold = vim.opt.foldenable:get() and searchKeyUsed
  local unpauseFold = not (vim.opt.foldenable:get()) and not searchKeyUsed
  if pauseFold then
    vim.opt.foldenable = false
  elseif unpauseFold then
    vim.opt.foldenable = true
    vim.cmd.normal('zv') -- after closing folds, keep the *current* fold open
    end
    end, vim.api.nvim_create_namespace('auto_pause_folds'))
EOF
