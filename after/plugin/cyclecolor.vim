function! CycleColorschemes()
    let s:colorschemes = [ 'default', 'habamax', 'retrobox', 'lunaperche', 'wildcharm', 'zaibatsu' ]
    if !exists("s:current")
        let s:current = 0
    endif
    let s:current = (s:current + 1) % len(s:colorschemes)
    execute 'colorscheme ' . s:colorschemes[s:current]
endfunction

