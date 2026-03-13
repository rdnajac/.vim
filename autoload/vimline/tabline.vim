" The value is evaluated like with 'statusline' and the following items are available:
" `tabpagenr()`
" `tabpagewinnr()`
" `tabpagebuflist()`
" Use "%1T" for the first label, "%2T" for the second one, etc.
" Use "%X" items for closing labels.
" Use `redrawtabline` to update the tabline when something changes.
" Check the 'columns' option for the space available.

function vimline#tabline#label(n)
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  return fnamemodify(git#root(bufname(buflist[winnr - 1])), ':~')
endfunction

""
" Lists all the tab pages labels. First go over all the tab pages and
" define labels for them. Then get the label for each tab page.
function vimline#tabline#() abort
  let s = ''
  for i in range(tabpagenr('$'))
    " select the highlighting
    if i + 1 == tabpagenr()
      let s ..= '%#TabLineSel#'
    else
      let s ..= '%#TabLine#'
    endif

    " set the tab page number (for mouse clicks)
    let s ..= '%' .. (i + 1) .. 'T'

    " the label is made by vimline#tabline#label()
    let s ..= ' %{vimline#tabline#label(' .. (i + 1) .. ')} '
  endfor

  " after the last tab page fill with TabLineFill and reset tab page nr
  let s ..= '%#TabLineFill#%T'

  " right-align the label to close the current tab page
  if tabpagenr('$') > 1
    let s ..= '%=%#TabLine#%999Xclose'
  endif

  return s
endfunction
