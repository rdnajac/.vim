" setting-tabline
" 	The tab pages line only appears as specified with the 'showtabline'
" 	option and only when there is no GUI tab line.  When 'e' is in
" 	'guioptions' and the GUI supports a tab line 'guitablabel' is used
" 	instead.  Note that the two tab pages lines are very different.
"
" 	The value is evaluated like with 'statusline'.  You can use
" 	|tabpagenr()|, |tabpagewinnr()| and |tabpagebuflist()| to figure out
" 	the text to be displayed.  Use "%1T" for the first label, "%2T" for
" 	the second one, etc.  Use "%X" items for closing labels.
"
" 	When changing something that is used in 'tabline' that does not
" 	trigger it to be updated, use |:redrawtabline|.
" 	This option cannot be set in a modeline when 'modelineexpr' is off.
"
" 	Keep in mind that only one of the tab pages is the current one, others
" 	are invisible and you can't jump to their windows.

" Check the 'columns' option for the space available.

""
" Since the number of tab labels will vary,
" you need to use an expression for the whole option.
set tabline=%!MyTabLine()

""
" Then define the MyTabLine() function to list all the tab pages labels.  A
" convenient method is to split it in two parts:  First go over all the tab
" pages and define labels for them.  Then get the label for each tab page. >

function MyTabLine()
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

    " the label is made by MyTabLabel()
    let s ..= ' %{MyTabLabel(' .. (i + 1) .. ')} '
  endfor

  " after the last tab page fill with TabLineFill and reset tab page nr
  let s ..= '%#TabLineFill#%T'

  " right-align the label to close the current tab page
  if tabpagenr('$') > 1
    let s ..= '%=%#TabLine#%999Xclose'
  endif

  return s
endfunction

""
" Now the MyTabLabel() function is called for each tab page to get its label.
function MyTabLabel(n)
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  return git#root(bufname(buflist[winnr - 1]))
endfunction

function vimline#tabline#() abort
  " dummy
endfunction

