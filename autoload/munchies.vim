" viml bindings for Snacks

function munchies#autocmds() abort
  lua Snacks.picker.autocmds()
endfunction

function munchies#keymaps() abort
  lua Snacks.picker.keymaps()
endfunction
