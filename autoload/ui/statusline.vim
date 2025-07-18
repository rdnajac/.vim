function ui#statusline#original() abort
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
