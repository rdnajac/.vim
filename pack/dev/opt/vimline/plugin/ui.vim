scriptencoding=utf-8

function s:original_statusline() abort
  let l:statusline = ''
  let l:statusline .= '%<'                " Left: truncated file path
  let l:statusline .= '%f'                " filename
  let l:statusline .= ' ' . '%h'          " help buffer flag
  let l:statusline .= '%w'                " preview window flag
  let l:statusline .= '%m'                " modified flag
  let l:statusline .= '%r'                " readonly flag

  let l:statusline .= ' %='               " Right alignment
  let l:statusline .= '%{ &showcmdloc == "statusline" ? "%-10.S " : "" }'
  let l:statusline .= '%{ exists("b:keymap_name") ? "<" .. b:keymap_name .. "> " : "" }'
  let l:statusline .= '%{ &busy > 0 ? "◐ " : "" }'
  let l:statusline .= '%{ &ruler ? ( &rulerformat == "" ? "%-14.(%l,%c%V%) %P" : &rulerformat ) : "" }'
  return l:statusline
endfunction

function! s:flags() abort
  let l:line = ''
  let l:line .= ui#components#i_filetype()
  let l:line .= ui#components#i_copilot()
  let l:line .= ui#components#i_treesitter()
  let l:line .= ui#components#i_lsp()
  let l:line .= ui#components#i_modified()
  let l:line .= ui#components#i_help()
  let l:line .= ui#components#i_readonly()
  return l:line
endfunction

" echom s:flags()

" function! s:handle_oil() abort
"   return v:lua.require('util.lualine.components.filetype_icon')()
" endfunction

function! MyTabline() abort
  let l:line = ''
  let l:line .= '%#Chromatophore_c# '
  let l:line .= ui#docsymbols#line()
  let l:line .= '%#Normal#'
  return l:line
endfunction

" let l:line .= ui#components#i_recording()
augroup RecordingStatus
  autocmd!
  autocmd RecordingEnter,RecordingLeave * redrawstatus
augroup END

function MyStatusline() abort
  let l:line = ''
  let l:line .= '%#Chromatophore_y#'
  " let line .= '%<'                " Left: truncated file path
  " let line .= '%f'                " filename
  " let line .= '%w'                " preview window flag

  let l:line .= ui#docsymbols#line()
  let l:line .= ' %='               " Right alignment
  let l:line .= ui#components#blink_status()
  let l:line .= '%{ exists("b:keymap_name") ? "<" .. b:keymap_name .. "> " : "" }'
  let l:line .= '%{ &busy > 0 ? "◐ " : "" }'
  let l:line .= ui#components#i_recording()
  let l:line .= ' %S '
  let l:line .= ui#mode#line()
  return line
endfunction

function! MyTmuxline() abort
  let [l:root, l:suffix] = git#RelativePath()
  let l:prefix = l:root !=# '' ? '󱉭 ' . l:root . '/' : ''
  let l:line = ''
  let l:line .= '%#Chromatophore_a# '
  let l:line .= l:prefix
  let l:line .= '%#Chromatophore_ab#🭛'
  let l:line .= '%#Chromatophore_b#'
  let l:line .= l:suffix
  let l:line .= ' %#Chromatophore_bc#🭛'
  let l:line .= '%#Chromatophore_c#'
  let l:line .= s:flags() . ' '
  return l:line
endfunction

function! Clock() abort
  let l:line = ''
  let l:line .= '%='
  let l:line .= '%#Chromatophore_z#'
  let l:line .= '   ' . strftime('%T') . ' '
  let l:line .= '%#Normal#'
  return l:line
endfunction

" export the statusline
function! TmuxLeft() abort
  return luaeval("require('util.tmuxline')(vim.fn['MyTmuxline']())")
endfunction

function! TmuxRight() abort
  return luaeval("require('util.tmuxline')(vim.fn['Clock']())")
endfunction

" statusline=%<%f %h%w%m%r %=%{% &showcmdloc == 'statusline' ? '%-10.S ' : '' %}%{% exists('b:keymap_name') ? '<'..b:keymap_name..'> ' : '' %}%{% &busy > 0 ? '◐ ' : '' %}%{% &ruler ? ( &rulerformat == '' ? '%-14.(%l,%c%V%) %P' : &rulerformat ) : '' %}
