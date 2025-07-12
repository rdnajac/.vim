" 24 simple pseudo-text objects
" -----------------------------
" i_ i. i: i, i; i| i/ i\ i* i+ i- i#
" a_ a. a: a, a; a| a/ a\ a* a+ a- a#
" can take a count: 2i: 3a/
for char in [ '_', '.', ':', ',', ';', '<bar>', '/', '<bslash>', '*', '+', '-', '#' ]
	execute "xnoremap i" . char . " :<C-u>execute 'normal! ' . v:count1 . 'T" . char . "v' . (v:count1 + (v:count1 - 1)) . 't" . char . "'<CR>"
	execute "onoremap i" . char . " :normal vi" . char . "<CR>"
	execute "xnoremap a" . char . " :<C-u>execute 'normal! ' . v:count1 . 'F" . char . "v' . (v:count1 + (v:count1 - 1)) . 'f" . char . "'<CR>"
	execute "onoremap a" . char . " :normal va" . char . "<CR>"
endfor

" Line pseudo-text objects
" ------------------------
" il al
xnoremap il g_o^
onoremap il :<C-u>normal vil<CR>
xnoremap al $o0
onoremap al :<C-u>normal val<CR>

" Number pseudo-text object (integer and float)
" ---------------------------------------------
" in
function! VisualNumber()
	call search('\d\([^0-9\.]\|$\)', 'cW')
	normal v
	call search('\(^\|[^0-9\.]\d\)', 'becW')
endfunction
xnoremap in :<C-u>call VisualNumber()<CR>
onoremap in :<C-u>normal vin<CR>

" Buffer pseudo-text objects
" --------------------------
" i% a%
xnoremap i% :<C-u>let z = @/\|1;/^./kz<CR>G??<CR>:let @/ = z<CR>V'z
onoremap i% :<C-u>normal vi%<CR>
xnoremap a% GoggV
onoremap a% :<C-u>normal va%<CR>

" Square brackets pseudo-text objects
" -----------------------------------
" ir ar
" can take a count: 2ar 3ir
xnoremap ir i[
onoremap ir :<C-u>execute 'normal v' . v:count1 . 'i['<CR>
xnoremap ar a[
onoremap ar :<C-u>execute 'normal v' . v:count1 . 'a['<CR>

" Block comment pseudo-text objects
" ---------------------------------
" i? a?
xnoremap a? [*o]*
onoremap a? :<C-u>normal va?V<CR>
xnoremap i? [*jo]*k
onoremap i? :<C-u>normal vi?V<CR>

" C comment pseudo-text object
" ----------------------------
" i? a?
xnoremap i? [*jo]*k
onoremap i? :<C-u>normal vi?V<CR>
xnoremap a? [*o]*
onoremap a? :<C-u>normal va?V<CR>

" Last khange pseudo-text objects ;-)
" -----------------------------------
" ik ak
xnoremap ik `]o`[
onoremap ik :<C-u>normal vik<CR>
onoremap ak :<C-u>normal vikV<CR>

" XML/HTML/etc. attribute pseudo-text object
" ------------------------------------------
" ix ax	
xnoremap ix a"oB
onoremap ix :<C-u>normal vix<CR>
xnoremap ax a"oBh
onoremap ax :<C-u>normal vax<CR>

" Fenced code block in Markdown
" -----------------------------
" if
" See https://stackoverflow.com/questions/75587279/quick-way-to-select-inside-a-fenced-code-block-in-markdown-using-vim
" To be put in after/ftplugin/markdown.vim
function! s:SelectInnerCodeBlock()
    function! IsFence()
        return getline('.') =~ '^```'
    endfunction

    function! IsOpeningFence()
        return IsFence() && getline(line('.'),'$')->filter({ _, val -> val =~ '^```'})->len() % 2 == 0
    endfunction

    function! IsBetweenFences()
        return synID(line("."), col("."), 0)->synIDattr('name') =~? 'markdownCodeBlock'
    endfunction

    function! IsClosingFence()
        return IsFence() && !IsOpeningFence()
    endfunction

    if IsOpeningFence() || IsBetweenFences()
        call search('^```', 'W')
        normal -
        call search('^```', 'Wbs')
        normal +
        normal V''
    elseif IsClosingFence()
        call search('^```', 'Wbs')
        normal +
        normal V''k
    else
        return
    endif
endfunction
xnoremap <buffer> <silent> if :<C-u>call <SID>SelectInnerCodeBlock()<CR>
onoremap <buffer> <silent> if :<C-u>call <SID>SelectInnerCodeBlock()<CR>
