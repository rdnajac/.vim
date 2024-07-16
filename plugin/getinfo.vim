" get info about the current cursor position
" aggregate it and send it to a popup window
function GetHi()
  let var1 = 'syntax: ' . synIDattr(synIDtrans(synID(line("."), col("."), 1)), "name")
  let output = [var1]
  for id in synstack(line("."), col("."))
    call add(output, 'highlight group: ' . synIDattr(id, "name"))
  endfor
  return join(output, "\n")
endfunction

function GetInfo()
  let info = GetHi()
  call Popup('info', split(info, "\n"))
endfunction


