" Execute the current file and display the output in a popup window
function! VX()
    let cmd = './' . expand('%')
    let output = systemlist(cmd)
    call Popup(output)
endfunction

command! -nargs=0 VX call VX()
